Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63E41F5EA
	for <linux-crypto@vger.kernel.org>; Sun, 23 Feb 2025 04:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740283373; cv=none; b=mPpHOb4YK9PuLiOzxpAGShceejgMFSqoXVCSCEW/WXruDqLBfGnYCLxTsTERciZZekcK76Hgy7Zxny4zJslDfm//FdrTiSKhFhg0E/4J90xXJMAXMXhzOPr0aRYyICPxnlSjIzcGIO/vDhu6ccfqEY3rTvWHqvMxJnoyZa6R6XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740283373; c=relaxed/simple;
	bh=kt8bEOKaMXqsB0Hnd+Ix9Yl8lVrPfZwch4RRsQ42UUE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FT30jVc803U+7o2lN1yywNhVPISZ40aknxfFhUC3MSN/rpejnDiJN2YJJsReDtqxmzOMcJlmd8+2lU+/7YAVCZS+xViJuZez86aUMwJlj3HDc6hH1Fcc9dQjFxJy0HJfVFNL8OtqCIo7V7+hJVZf/fpIRhV9wNM2d9rjPfvonyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=AGEvK1Qw; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="AGEvK1Qw"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2fcff77ff9bso2187077a91.0
        for <linux-crypto@vger.kernel.org>; Sat, 22 Feb 2025 20:02:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1740283371; x=1740888171; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7X/a6yKMJK840olzn4NcUlQ7572WIMjZpQOK9Wp6mVY=;
        b=AGEvK1QwAMZZp4zt9oUGtimLr9w/pfh2rXu+hbuqUkQM/VMjchb2ShYenwUbZkKMyI
         fduKGGGNrLUfrHIw94WVm/CJBQh6YvYLSWFTLunfVS/VG3jpGaV0Ui73rf2ZeYcmWKEZ
         KgKd4PvO7T74tl9moKQjRQAH/+/iLxLa3xLGc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740283371; x=1740888171;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7X/a6yKMJK840olzn4NcUlQ7572WIMjZpQOK9Wp6mVY=;
        b=iAjx0c7rIwh1jm7sKiTTtC5oDnoRSNF45b35JBV9J1c2xU5Nm5KcFXqmUhq/4S+vyx
         R4J0HkzJ1TWKkJzOoxtacrQxZPtop0glUbfaCVNEhCPTkR9DvR3yOopb++tTPxS+0Kh2
         kPQy3uLWM9cXtWxV60aUVFr3Bz0582J2pchrMn8QWP0OVSQz1MmnoZkM9Jk3fQM5DO8f
         IuQzTiyqI6dbGkYGLbOPx23GR/tWk7sjW6E6rLIgp8ilz98mq+HISZkKXyFv862EbkFe
         mTGGAVp9VLAgkdRgPJw3V0qBc+fjJRA/VOmCijgHvUQpP3Vtavk+W5KLdYMoiYbvENmX
         NSig==
X-Forwarded-Encrypted: i=1; AJvYcCXF3SBbRJl8Iyhiwfkpo0CJHd8Zb0BY7eoleZiIRYq5ZZC25uD/gkS4qwY6pOocRSo0QD/FbBPpnQwjdBA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyyHCavUWtVkRuKqWiC0eSEHL2hRrRYH7idMrhmfLakA//L2fpm
	JKBa0M7UdpAoWHeOrJY/+vmNWTTWXvFx0nXXe8S46ULCb7g0jtu0ZaoUPhOwEw==
X-Gm-Gg: ASbGncvV9ZMvv4+DTURjZsVyBFY3+xT9DFp0FtK3iSWoyylpNlxlGxLqB/DVU8zKHki
	2QtBTd3hIoeY+UJ5qHZO6QUaON4MLYZ6SmcAwDDCdVtG9BCP9MjEsyIDxgU+Qcao3lfGwIakwN8
	5JAXfauD311mxD90kkuGJ7gR9JMVHkHiVg8a1Pw9NyHIPXBlgCOxuMoQkEBC2oHKs79YrLbgBFO
	gRP1eBK6mewP1lXV2Low58t/Cr+bqHjztBUUHoEYvasoESDfyAY+KUIPSeYBohcj7Kj2oZHATSD
	kwi/rMo6VqOvHThMvs9EMsx1J1Qi
X-Google-Smtp-Source: AGHT+IGGp+0kbnPW/KjNjCOzaQWqa83C+/uSTXFIzfy4XdmQFLXNo8MIxjAHIe5svT4w4lKj1mV4VA==
X-Received: by 2002:a17:90b:37c7:b0:2ee:8ea0:6b9c with SMTP id 98e67ed59e1d1-2fce78a508dmr16896210a91.12.1740283370980;
        Sat, 22 Feb 2025 20:02:50 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:badf:54f:bbc8:4593])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-220d556fbeesm157324385ad.183.2025.02.22.20.02.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Feb 2025 20:02:50 -0800 (PST)
Date: Sun, 23 Feb 2025 13:02:41 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Barry Song <21cnbao@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Minchan Kim <minchan@kernel.org>, "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "nphamcs@gmail.com" <nphamcs@gmail.com>, 
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, "usamaarif642@gmail.com" <usamaarif642@gmail.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>, 
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>, 
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com" <surenb@google.com>, 
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>, "Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, 
	"Gopal, Vinodh" <vinodh.gopal@intel.com>
Subject: Re: [PATCH v5 02/12] crypto: acomp - Define new interfaces for
 compress/decompress batching.
Message-ID: <o7qvt25dxoxcxj5ec2tbf5y5nopi4mkiuklo63rnyc7bldxwdm@2l5lkllmaynk>
References: <Z7F1B_blIbByYBzz@gondor.apana.org.au>
 <Z7dnPh4tPxLO1UEo@google.com>
 <CAGsJ_4yVFG-C=nJWp8xda3eLZENc4dpU-d4VyFswOitiXe+G_Q@mail.gmail.com>
 <dhj6msbvbyoz7iwrjnjkvoljvkh2pgxrwzqf67gdinverixvr5@e3ld7oeketgw>
 <lu3j2kr3m2b53ze2covbywh6a7vvrscbkoplwnq4ov24g2cfso@572bdcsobd4a>
 <Z7poTnlv-1DStRZQ@gondor.apana.org.au>
 <u7t7gibspxu3lujdl4hambr72qd6o5u33udbojihngznlyistk@gmyyhwjuiwxc>
 <Z7qNf4NerHrflmfV@gondor.apana.org.au>
 <cxspxz5jeiigd34cl7x3asyx4lowefjpffj3ip4mwpxdwh34e6@xzpqbmlihbcg>
 <Z7qYUCAqh2YFQ908@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z7qYUCAqh2YFQ908@gondor.apana.org.au>

On (25/02/23 11:38), Herbert Xu wrote:
> On Sun, Feb 23, 2025 at 12:12:47PM +0900, Sergey Senozhatsky wrote:
> >
> > > > It also seems that there is no common way of reporting dst_but overflow.
> > > > Some algos return -ENOSPC immediately, some don't return anything at all,
> > > > and deflate does it's own thing - there are these places where they see
> > > > they are out of out space but they Z_OK it
> > > > 
> > > > if (s->pending != 0) {
> > > > 	flush_pending(strm);
> > > > 	if (strm->avail_out == 0) {
> > > > 		/* Since avail_out is 0, deflate will be called again with
> > > > 		 * more output space, but possibly with both pending and
> > > > 		 * avail_in equal to zero. There won't be anything to do,
> > > > 		 * but this is not an error situation so make sure we
> > > > 		 * return OK instead of BUF_ERROR at next call of deflate:
> > > > 		 */
> > > > 		s->last_flush = -1;
> > > > 		return Z_OK;
> > > > 	}
> > > > }
> > > 
> > > Z_OK is actually an error, see crypto/deflate.c:
> > 
> > I saw Z_STREAM_END, but deflate states "this is not an error" and
> > there are more places like this.
> 
> That would be a serious bug in deflate.  Where did you see it
> return Z_STREAM_END in case of an overrun or error?

Oh, sorry for the confusion, I was talking about Z_OK for overruns.

> > So it will ENOSPC all errors, not sure how good that is.  We also
> > have lz4/lz4hc that return the number of bytes "(((char *)op) - dest)"
> > if successful and 0 otherwise.  So any error is 0. dst_buf overrun
> > is also 0, impossible to tell the difference, again not sure if we
> > can just ENOSPC.
> 
> I'm talking about the Crypto API calling convention.  Individual
> compression libraries obviously have vastly different calling
> conventions.
> 
> In the Crypto API, lz4 will return -EINVAL:
> 
> 	int out_len = LZ4_compress_default(src, dst,
> 		slen, *dlen, ctx);
> 
> 	if (!out_len)
> 		return -EINVAL;

Right, so you said that for deflate it could be

       ret = zlib_deflate(stream, Z_FINISH);
       if (ret != Z_STREAM_END) {
               ret = -ENOSPC;          // and not -EINVAL
               goto out;
       }

if I understood it correctly.  Which would make it: return 0 on success
or -ENOSPC otherwise.  So if crypto API wants consistency and return -ENOSPC
for buffer overruns, then for lz4/lz4hc it also becomes binary: either 0 or
-ENOSCP.  Current -EINVAL return looks better to me, both for deflate and
for lz4/lz4hc.  -ENOSPC is an actionable error code, a user can double the
dst_out size and retry compression etc., while in reality it could be some
SW/HW issue that is misreported as -ENOSPC.



So re-iterating Barry's points:

> My point is:
> 1. All drivers must be capable of handling dst_buf overflow.

Not the case.

> 2. All drivers must return a consistent and dedicated error code for
> dst_buf overflow.

Not the case.
