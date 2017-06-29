From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 0/2] staging: ccree: Fix coding style and remove warnings
Date: Thu, 29 Jun 2017 16:18:29 +0200
Message-ID: <20170629141829.GA29662@kroah.com>
References: <1498642633-3260-1-git-send-email-karthik@techveda.org>
 <CAOtvUMdpwFaMDh2qCnB=keZQAc6ssXM+u39GPaf0ASGr002OJA@mail.gmail.com>
 <1f681a83-4413-8c9d-ab75-c223b6c8b55b@techveda.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
 Linux kernel mailing list <linux-kernel@vger.kernel.org>,
 linux-crypto@vger.kernel.org, sunil.m@techveda.org
To: karthik <karthik@techveda.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1f681a83-4413-8c9d-ab75-c223b6c8b55b@techveda.org>
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

On Thu, Jun 29, 2017 at 04:13:38PM +0530, karthik wrote:
> On Wednesday 28 June 2017 03:15 PM, Gilad Ben-Yossef wrote:
> > Thank you Karthik,
> > 
> > On Wed, Jun 28, 2017 at 12:37 PM,  <karthik@techveda.org> wrote:
> > > From: Karthik Tummala <karthik@techveda.org>
> > > 
> > > This patch series fixes coding style and removes the following
> > > checkpatch.pl warnings:
> > > 
> > > Prefer using '"%s...", __func__' to using the function's name,
> > > in a string.
> > 
> > This one is good.
> > > 
> > > Braces {} are not necessary for single statement blocks.
> > 
> > I have already sent a patch addressing this and some other things
> > yesterday/
> > 
> > > 
> > > Rebased on top of next-20170627.
> > > Patches were tested and built on next-20170627
> > 
> > Can you please check patch 1 still applies after yesterdays patch series?
> Hi, I have applied your patch series and then tried to apply patch 1 and it
> failed. Should I wait until the patch series gets accepted and then continue
> my work on the new linux-next release ? or is there any other option ?

You need to rebased on top of these changes.  All of them are now in
staging-testing, soon to move to staging-next in a day or so.  Rebase on
there and resend.

thanks,

greg k-h
