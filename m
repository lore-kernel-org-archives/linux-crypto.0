From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] Re: Broken userspace crypto in linux-4.1.18
Date: Tue, 23 Feb 2016 18:24:35 -0800
Message-ID: <20160224022435.GA3319@kroah.com>
References: <56C50725.6080408@whissi.de>
 <4580306.arupsYiYbb@positron.chronox.de>
 <56C591E7.5080808@suse.cz>
 <56C5A66E.5010905@whissi.de>
 <56C87929.8040304@whissi.de>
 <56C9E865.3050500@gmail.com>
 <56CCC8D3.8040001@gmail.com>
 <56CCCD6D.3040506@oracle.com>
 <CAA-+O6H8TQxrKOQAL+s+PGnkOJe-f3dEs-wKGbM1BFZ7_aC2dg@mail.gmail.com>
 <56CCF50F.5010803@whissi.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sasha.levin@oracle.com>,
	Milan Broz <gmazyland@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
	Stephan Mueller <smueller@chronox.de>,
	Willy Tarreau <w@1wt.eu>,
	"dvyukov@google.com" <dvyukov@google.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Ondrej Kozina <okozina@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: "Thomas D." <whissi@whissi.de>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56CCF50F.5010803@whissi.de>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Feb 24, 2016 at 01:10:55AM +0100, Thomas D. wrote:
> Hi,
> 
> I have applied Milan's patch on top of 4.1.18. I can reboot and open all
> of my LUKS-encrypted disks. "cryptsetup benchmark" also works.
> 
> However, don't we need all the recent changes from
> "crypto/algif_skcipher.c", too?

Can someone just backport the full patches in a proper format that I can
apply them in for the 3.14 and 3.10 kernels?  I told people that they
failed to apply, or at least I thought I did...

thanks,

greg k-h
