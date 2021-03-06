/*
 * Copyright (C) 2017 HAT Data Exchange Ltd
 * SPDX-License-Identifier: AGPL-3.0
 *
 * This file is part of the Hub of All Things project (HAT).
 *
 * HAT is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License
 * as published by the Free Software Foundation, version 3 of
 * the License.
 *
 * HAT is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See
 * the GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General
 * Public License along with this program. If not, see
 * <http://www.gnu.org/licenses/>.
 *
 * Written by Andrius Aucinas <andrius.aucinas@hatdex.org>
 * 2 / 2017
 */

package org.hatdex.hat.modules

import com.google.inject.AbstractModule
import net.codingwell.scalaguice.ScalaModule
import org.hatdex.hat.resourceManagement.actors.{ HatServerActor, HatServerProviderActor }
import org.hatdex.hat.resourceManagement.{ HatDatabaseProvider, HatDatabaseProviderMilliner, HatKeyProvider, HatKeyProviderMilliner }
import play.api.libs.concurrent.AkkaGuiceSupport

class HatServerProviderModule extends AbstractModule with ScalaModule with AkkaGuiceSupport {

  def configure = {
    bindActor[HatServerProviderActor]("hatServerProviderActor")
    bindActorFactory[HatServerActor, HatServerActor.Factory]

    bind[HatDatabaseProvider].to[HatDatabaseProviderMilliner]
    bind[HatKeyProvider].to[HatKeyProviderMilliner]
  }

}
