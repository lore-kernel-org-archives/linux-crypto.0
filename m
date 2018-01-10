From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Getting the ccree driver out of staging
Date: Wed, 10 Jan 2018 17:39:26 +0100
Message-ID: <20180110163926.GA25674@kroah.com>
References: <CAOtvUMdo_ZJ-M-=apA1a=70KyVBX2J0pEVc+Uc9i=rYWCie6Hw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
 Herbert Xu <herbert@gondor.apana.org.au>, Ofir Drang <Ofir.Drang@arm.com>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <CAOtvUMdo_ZJ-M-=apA1a=70KyVBX2J0pEVc+Uc9i=rYWCie6Hw@mail.gmail.com>
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

On Wed, Jan 10, 2018 at 08:54:55AM +0200, Gilad Ben-Yossef wrote:
> Hi folks,
> 
> With the enormous help of people in the to and CCed lists I've gotten
> the ccree driver to a point I believe it is ready to graduate out of
> the staging tree:
> 
> - The code base has been reduced by something by 30% and is *much*
> more  readable and manageable.
> - The very few checkpatch warnings are all false positives (one due to
> dt bindings going through the crypto tree, the others due to harmless
> macro argument reuse)
> and the few sparse output are equally benign.
> - The driver follows the crypto API expected behavior as much as I can tell.
> - Fixed all the bugs I could fine as a result of tcrypt tests.
> - It works :-)
> 
> There are obviously more things todo, but I believe they are out of
> scope for staging.
> 
> So, if you see something that still needs work, kindly let me know.
> Alternatively, will you accept a patch moving it to drivers/crypto/?

It might make more sense to just send a "new" patch adding the driver to
drivers/crypto/ and if that is accepted, we can drop it from staging.
That way it's easier for the crypto developers to review it.

But it's up to them, whatever they want is fine with me.

thanks,

greg k-h
