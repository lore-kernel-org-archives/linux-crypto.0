From: "Thomas D." <whissi@whissi.de>
Subject: Re: [PATCH] Re: Broken userspace crypto in linux-4.1.18
Date: Wed, 24 Feb 2016 01:10:55 +0100
Message-ID: <56CCF50F.5010803@whissi.de>
References: <56C47DF9.6030704@whissi.de> <20160217233353.GC31125@1wt.eu>
 <56C50725.6080408@whissi.de> <4580306.arupsYiYbb@positron.chronox.de>
 <56C591E7.5080808@suse.cz> <56C5A66E.5010905@whissi.de>
 <56C87929.8040304@whissi.de> <56C9E865.3050500@gmail.com>
 <56CCC8D3.8040001@gmail.com> <56CCCD6D.3040506@oracle.com>
 <CAA-+O6H8TQxrKOQAL+s+PGnkOJe-f3dEs-wKGbM1BFZ7_aC2dg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Willy Tarreau <w@1wt.eu>,
	"dvyukov@google.com" <dvyukov@google.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Greg KH <gregkh@linuxfoundation.org>,
	Ondrej Kozina <okozina@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sasha.levin@oracle.com>,
	Milan Broz <gmazyland@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CAA-+O6H8TQxrKOQAL+s+PGnkOJe-f3dEs-wKGbM1BFZ7_aC2dg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

I have applied Milan's patch on top of 4.1.18. I can reboot and open all
of my LUKS-encrypted disks. "cryptsetup benchmark" also works.

However, don't we need all the recent changes from
"crypto/algif_skcipher.c", too?


-Thomas
