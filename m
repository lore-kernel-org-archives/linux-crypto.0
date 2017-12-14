From: Philippe Ombredanne <pombredanne@nexb.com>
Subject: Re: [PATCH 04/10] staging: ccree: staging: ccree: replace sysfs by
 debugfs interface
Date: Thu, 14 Dec 2017 15:30:27 +0100
Message-ID: <CAOFm3uHgcmO0bS6HXX9x+zdWsqAxd3BfeDePF_=Q_SpwB4ox3A@mail.gmail.com>
References: <1513260170-26346-1-git-send-email-gilad@benyossef.com>
 <1513260170-26346-5-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 driverdev-devel@linuxdriverproject.org, LKML <linux-kernel@vger.kernel.org>,
 linux-crypto@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1513260170-26346-5-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

Gilad,

On Thu, Dec 14, 2017 at 3:02 PM, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> The ccree driver has had a none standard sysfs interface for debugging.
> Replace it with a proper debugfs interface.
>
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>

<snip>

> --- /dev/null
> +++ b/drivers/staging/ccree/cc_debugfs.c
> @@ -0,0 +1,114 @@
> +/*
> + * Copyright (C) 2012-2017 ARM Limited or its affiliates.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, see <http://www.gnu.org/licenses/>.
> + */

Could you use the new SPDX tags instead of this fine and long
boilerplate? See Thomas doc for details [1]

You could spare the world from ~14 lines of this fine legalese with this:

// SPDX-License-Identifier: GPL-2.0
// Copyright (C) 2012-2017 ARM Limited or its affiliates.

If you wonder about the C++ style comment, read Thomas doc patches [1]
and check the comments made on the list by Linus.

If you could spread the word out in your team too, this would be much welcomed!
Thanks!

[1] https://lkml.org/lkml/2017/12/4/934

--
Cordially
Philippe Ombredanne
