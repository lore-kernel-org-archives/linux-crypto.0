From: Ryan Chen <yu.chen.surf@gmail.com>
Subject: Re: [PATCH 0/4][RFC v2] Introduce the in-kernel hibernation encryption
Date: Tue, 7 Aug 2018 15:49:06 +0800
Message-ID: <CADjb_WTrJ_yjsNk79XYJyA5VB3dwK5cUadCumYRkzogOzm_nPA@mail.gmail.com>
References: <20180718202235.GA4132@amd> <20180718235851.GA22170@sandybridge-desktop>
 <20180719110149.GA4679@amd> <20180719132003.GA30981@sandybridge-desktop>
 <20180720102532.GA20284@amd> <1532346156.3057.11.camel@suse.com>
 <20180723162302.GA4503@sandybridge-desktop> <1532590246.7411.3.camel@suse.com>
 <20180806075754.GA12124@chenyu-desktop> <1533550820.15815.14.camel@suse.com> <20180807073840.GA17894@chenyu-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: oneukum@suse.com, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Eric Biggers <ebiggers@google.com>, jlee@suse.com,
        "Theodore Ts'o" <tytso@mit.edu>, smueller@chronox.de,
        denkenz@gmail.com, Linux PM list <linux-pm@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kookoo.gu@intel.com, Zhang Rui <rui.zhang@intel.com>
To: Chen Yu <yu.c.chen@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180807073840.GA17894@chenyu-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Aug 7, 2018 at 3:33 PM Yu Chen <yu.c.chen@intel.com> wrote:
>
> On Mon, Aug 06, 2018 at 12:20:20PM +0200, Oliver Neukum wrote:
> > On Mo, 2018-08-06 at 15:57 +0800, Yu Chen wrote:
> > > Hi Oliver,
> > > On Thu, Jul 26, 2018 at 09:30:46AM +0200, Oliver Neukum wrote:
> > > > On Di, 2018-07-24 at 00:23 +0800, Yu Chen wrote:
> > > > >
> > > > > Good point, we once tried to generate key in kernel, but people
> > > > > suggest to generate key in userspace and provide it to the
> > > > > kernel, which is what ecryptfs do currently, so it seems this
> > > > > should also be safe for encryption in kernel.
> > > > > https://www.spinics.net/lists/linux-crypto/msg33145.html
> > > > > Thus Chun-Yi's signature can use EFI key and both the key from
> > > > > user space.
> > > >
> > > > Hi,
> > > >
> > > > ecryptfs can trust user space. It is supposed to keep data
> > > > safe while the system is inoperative.
> > >
> > > Humm, I did not quite get the point here, let's take fscrypt
> >
> > While the system is running and the fs is mounted, your data
> > is as secure as root access to your machine, right? You encrypt
> > a disk primarily so data cannot be recovered (and altered) while
> > the system is not running.
> >
> > Secure Boot does not trust root fully. There is a cryptographic
> > chain of trust and user space is not part of it.
> >
> Okay, I see. So if we want to use secure boot mechanism for
> hibernation encryption, user space is trusted.
s/ is trusted/is not trusted/
