From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH v4 8/8] zram: enable contextless compression alg in zram
Date: Thu, 15 Oct 2015 09:45:22 +0900
Message-ID: <20151015004522.GA4900@js1304-P5Q-DELUXE>
References: <1444808304-29320-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1444808304-29320-9-git-send-email-iamjoonsoo.kim@lge.com>
 <20151015002903.GB1735@swordfish>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>,
	Nitin Gupta <ngupta@vflare.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151015002903.GB1735@swordfish>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 15, 2015 at 09:29:03AM +0900, Sergey Senozhatsky wrote:
> Hi,
> 
> On (10/14/15 16:38), Joonsoo Kim wrote:
> [..]
> >  static const char * const backends[] = {
> >  	"lzo",
> > -#ifdef CONFIG_ZRAM_LZ4_COMPRESS
> >  	"lz4",
> > -#endif
> >  	NULL
> >  };
> >  
> >  static const char *find_backend(const char *compress)
> >  {
> > -	int i = 0;
> > -	while (backends[i]) {
> > -		if (sysfs_streq(compress, backends[i]) &&
> > -			crypto_has_comp(backends[i], 0, 0))
> > -			break;
> > -		i++;
> > -	}
> > -	return backends[i];
> > +	if (crypto_has_comp(compress, 0, 0))
> > +		return compress;
> > +
> > +	return NULL;
> >  }
> >  
> >  static void zcomp_strm_free(struct zcomp *comp, struct zcomp_strm *zstrm)
> > @@ -277,6 +271,9 @@ ssize_t zcomp_available_show(const char *comp, char *buf)
> >  	int i = 0;
> >  
> >  	while (backends[i]) {
> > +		if (!crypto_has_comp(backends[i], 0, 0))
> > +			continue;
> > +
> 
> hm... this sort of looks a bit `unnatural' to me. we have two _independent_
> sets -- what zram supports and what crypto supports. that's why you have
> to do extra work and consult crypto. can we return back the old scheme:
> use ifdef CONFIG in backends, but replace CONFIG_ZRAM with CONFIG_CRYPTO?
> 
> e.g.
> 
> 	static const char * const backends[] = {
> 		"lzo",
> 	#ifdef CONFIG_CRYPTO_LZ4
> 		"lz4",
> 	#endif
> 		NULL
> 	};
> 
> 
> so you can remove `crypto_has_comp(backends[i], 0, 0)' from
> zcomp_available_show(), because zram will support *only* what
> crypto supports.

Hello, Sergey.

Okay. I will change it in next spin.

Anyway, now I noticed that crypto_has_comp() is not proper API to
check contextless compression algorithm. I will change it, too.

Thanks.
