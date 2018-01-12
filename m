From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 1/2] crypto: Implement a generic crypto statistics
Date: Fri, 12 Jan 2018 10:11:18 +0100
Message-ID: <16302559.hxlYq3rOsN@tauon.chronox.de>
References: <1515700617-3513-1-git-send-email-clabbe@baylibre.com> <3297958.ndliyBY1jk@tauon.chronox.de> <20180112090730.GA15630@Red>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        nhorman@tuxdriver.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: LABBE Corentin <clabbe@baylibre.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180112090730.GA15630@Red>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Freitag, 12. Januar 2018, 10:07:30 CET schrieb LABBE Corentin:

Hi LABBE,

> 
> > > diff --git a/include/uapi/linux/cryptouser.h
> > > b/include/uapi/linux/cryptouser.h index 19bf0ca6d635..15e51ccb3679
> > > 100644
> > > --- a/include/uapi/linux/cryptouser.h
> > > +++ b/include/uapi/linux/cryptouser.h
> > > @@ -73,6 +73,8 @@ struct crypto_report_hash {
> > > 
> > >  	char type[CRYPTO_MAX_NAME];
> > >  	unsigned int blocksize;
> > >  	unsigned int digestsize;
> > > 
> > > +	__u64 stat_hash;
> > 
> > Why do you use __u64? The atomic_t variable is an int, i.e. 32 bit. Thus I
> > would think that __u32 would suffice?
> 
> You are right, I will downgrade to __u32
> But I think I will set len stats to atomic64/__u64 and keep count on
> atomic_t/__u32.

Fine with me.

> > > +	__u64 stat_hash_tlen;
> > > 
> > >  };
> > 
> > What I am slightly unsure here is: how should user space detect whether
> > these additional parameters are part of the NETLINK_USER API or not? I
> > use that interface in my libkcapi whose binary may be used on multiple
> > different kernel versions. How should that library operate if one kernel
> > has these parameters and another does not?
> 
> Userspace could check for kernel version and know if stat are present or
> not. Another way is to add a new netlink request.

Well, I am not sure that checking the kernel version is good enough. Distros 
and other vendors may backport this patch. This means that for some older 
kernel versions this interface is present.

Hence I would rather opt for a separate stat message where the user spacee 
caller receives an error on kernels that does not support it.

Ciao
Stephan
