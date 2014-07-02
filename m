From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 1/3] ima: use ahash API for file hash calculation
Date: Wed, 02 Jul 2014 15:38:00 -0400
Message-ID: <1404329880.596.92.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <cover.1404245510.git.d.kasatkin@samsung.com>
	 <72d68808fd8db2b896a459b120f3e550e5f976c1.1404245510.git.d.kasatkin@samsung.com>
	 <1404323065.596.65.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <CACE9dm8vx9b-n4b+0NAvp=9Er4uPWGwa8eYSGtkiAPv5ahve4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ima-devel@lists.sourceforge.net,
	linux-security-module <linux-security-module@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	Dmitry Kasatkin <d.kasatkin@samsung.com>
To: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CACE9dm8vx9b-n4b+0NAvp=9Er4uPWGwa8eYSGtkiAPv5ahve4A@mail.gmail.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 2014-07-02 at 21:21 +0300, Dmitry Kasatkin wrote: 
> On 2 July 2014 20:44, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > On Tue, 2014-07-01 at 23:12 +0300, Dmitry Kasatkin wrote:
> >
> >> -/*
> >> - * Calculate the MD5/SHA1 file digest
> >> - */
> >> +static struct crypto_ahash *ima_alloc_atfm(enum hash_algo algo)
> >> +{
> >> +     struct crypto_ahash *tfm = ima_ahash_tfm;
> >> +     int rc;
> >> +
> >> +     if ((algo != ima_hash_algo && algo < HASH_ALGO__LAST) || !tfm) {
> >> +             tfm = crypto_alloc_ahash(hash_algo_name[algo], 0, 0);
> >
> > In the case where algo isn't the same as ima_hash_algo, won't this
> > replace the existing ima_ahash_tfm without freeing it?
> >
> 
> Look to next comment...

Yep, my mistake in reading the code.

Mimi

