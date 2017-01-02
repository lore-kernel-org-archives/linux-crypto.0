From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 0/3] crypto: picoxcell - Cleanups removing non-DT code
Date: Mon, 02 Jan 2017 18:10:44 +0100
Message-ID: <2309314.lMWYhcWsTB@wuerfel>
References: <1483376819-26726-1-git-send-email-javier@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, Jamie Iles <jamie@jamieiles.com>,
 "David S. Miller" <davem@davemloft.net>, linux-arm-kernel@lists.infradead.org
To: Javier Martinez Canillas <javier@osg.samsung.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1483376819-26726-1-git-send-email-javier@osg.samsung.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

On Monday, January 2, 2017 2:06:56 PM CET Javier Martinez Canillas wrote:
> 
> This small series contains a couple of cleanups that removes some driver's code
> that isn't needed due the driver being for a DT-only platform.
> 
> The changes were suggested by Arnd Bergmann as a response to a previous patch:
> https://lkml.org/lkml/2017/1/2/342
> 
> Patch #1 allows the driver to be built when the COMPILE_TEST option is enabled.
> Patch #2 removes the platform ID table since isn't needed for DT-only drivers.
> Patch #3 removes a wrapper function that's also not needed if driver is DT-only.
> 
> 

Looks good, but I don't know if the first patch causes some build warnings
on non-ARM platforms, better wait at least for the 0-day build results,
and maybe build-test on x86-32 and x86-64.

	Arnd
