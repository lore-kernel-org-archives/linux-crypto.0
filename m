Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4664E2EA151
	for <linux-crypto@vger.kernel.org>; Tue, 24 Feb 2026 22:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771970509; cv=none; b=teSdsjU44TT3SIt6sHBtFXsBLQHuwCI4EWK0Iug0GVFT87L+EaHipYcUlnRiOZWUpyO4CMvpebCs02f/tJ6R7Uqo6MxCl75soN+FWO2jESTSm18Wmw7WN5CywlKqM8eR+zXKKTcrcm5CT1ffORJEgrMKnBjyCYybIcVT5Z6YusM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771970509; c=relaxed/simple;
	bh=gNo+Luqh0EqEViTKORbAtKlxTP1njg8YqxJJycW7MHY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PvmGKUNg0T8z+BRZqseVC0VF525bbii5Nfke5cK29zJeyVrjlVnsxuRon0P+PL8GW7D4NohIkwEKz39oZGWDi0sMdxuxe/Y5NEDJox+CvPZH2aoek3+l6eNSebavcu11aQozCiEsrQFvi9K9VAv59v9ReCunX0oocBOjjF+JHUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K3wuEiZZ; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K3wuEiZZ"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4362197d174so3849834f8f.3
        for <linux-crypto@vger.kernel.org>; Tue, 24 Feb 2026 14:01:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771970507; x=1772575307; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mfa86fLMSPUVmW4YbSbkR35RBg4PgJbe2U1gOw3VAbE=;
        b=K3wuEiZZVRsC8chXP2KkpIvkbyUpYDC663TV/a8fS8+QDOyACwYIdS4WR+h1JBP8pf
         jmLJsztYYMUJlICUBHZiJSgE0cYwZp02sJmXjuWThcHww9iavjXM8YR6gV+AhL2NbKb8
         bg6pSMD/5vNN0BgffIFkWrxX4VqbTgE3XDQlEKb1JbcuiAkmc/fSng/RITG2Q9CRkrS7
         wSa+3v6Db8ec055NW2m3bPDnmY3kLw1UWedDBYc3kUsrmTDSSr8j7ZHgetmGfppZeuN3
         +xe3yC/Tuq2Jvs/KH05vFSfpAS1fbYncn0OdwWudCIkcx2XevckZrsGrZWKK5Vm78zHE
         A7Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771970507; x=1772575307;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Mfa86fLMSPUVmW4YbSbkR35RBg4PgJbe2U1gOw3VAbE=;
        b=fAotaetvzCBnwN3YLihNGxm6Qfh/K8xsV3B4mLSbJhCGCWTJZzNwodZFHwAh7Kxrtc
         k5hVXJCAG6gFCKSZdgPT6UWyMEGO5vVG11MyKXTnGm08PiXkho4VaWC1hO9vEodgavq3
         u1EeO5bs200zyw6rVgag438rC/25jK6zITvyTIZMjGr+FGG6OIouONGCkWmOCJmaQeV6
         21eqSR74Ek32PkrrK9xwIVEAaB6kxfqfxHVV6WX5UEWdGag/82hZx0Kqd5QMdHdYGnVZ
         WDcWPGnzHGjZc+pPVv/TWeHZbwMnZgEfgb+1i/8/zGKS+Vwyk53t3h9E9yXVsNNe4aFs
         wPKQ==
X-Forwarded-Encrypted: i=1; AJvYcCWqCr2pEvm5K0fU9G0qJ3H/B2JslvbWms5KgACZcBqbzCUQ0P82Z+AF7kSs6M7qqkK8uMpQiu9g1q4yY9c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy50XqfMbZuNb10o4owlHerxm4OWyLGAu0ubN/EUEZA9ZvVv89a
	6wm7iRkX5l4mHTIACz3Lr0dvq/EGFdNxGc8UrmFjUkZuP19ihqvD9gCu
X-Gm-Gg: ATEYQzyZz6LeB/8TorEbAB00n2nnKHpE4ZfzrkAXbnez5afwGl88Hh7WrsC+d1CaEOD
	ln+oGCnqhO7+UF7x6SrnUGm7tkjP5zTvxsHp4AcNUwHsVezrrJT5LIGAeoyJABpEcqaRZ2dfdqF
	bd6eMb+3uLToQz6RmvzL1RmrFOo20g4lP4x+O/pXc+YqpD7o9qdvZZEXu2Ft4JTwt507DClkmbd
	RM/nifGYSckCe+HhPE7TAj9nI63lpPDUTBsLHghp18tcNoER57HfmDcHEkUA9pVIKUvJiB+hp7u
	8HBKgv7sZ8+l88VplkOeQ/9josEdZWlcKHMOcCvYUigPlAbb6p3HkTVPhHJt8W0glHl27lQdAm4
	wJqGvddryVxXsMqaaT6Zu25OlqyuCd9aCVQRVeV/iZo44pkLudGPN+4VvQiNQTSoDgZpBWo7qUb
	fqNWhCP6W21k6jxjUdIW1/4RXjGfjI9Y8z32wQGFKPyEoaP566m2ZRuLxo+AiYPXiQLEr8w1lR9
	nY=
X-Received: by 2002:a05:6000:22c1:b0:435:a2f8:1534 with SMTP id ffacd0b85a97d-4396f181357mr23507281f8f.49.1771970506403;
        Tue, 24 Feb 2026 14:01:46 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43970d4c95dsm32330432f8f.33.2026.02.24.14.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 14:01:45 -0800 (PST)
Date: Tue, 24 Feb 2026 22:01:44 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
 <davem@davemloft.net>, Suman Kumar Chakraborty
 <suman.kumar.chakraborty@intel.com>, Vijay Sundar Selvamani
 <vijay.sundar.selvamani@intel.com>, George Abraham P
 <george.abraham.p@intel.com>, <qat-linux@intel.com>,
 <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH next] crypto: qat - replace avg_array() with a better
 function
Message-ID: <20260224220144.231b17a5@pumpkin>
In-Reply-To: <aZ3p2dQFDNOgyQVz@gcabiddu-mobl.ger.corp.intel.com>
References: <20260206210940.315817-1-david.laight.linux@gmail.com>
	<aZ3p2dQFDNOgyQVz@gcabiddu-mobl.ger.corp.intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 24 Feb 2026 18:11:37 +0000
Giovanni Cabiddu <giovanni.cabiddu@intel.com> wrote:

> On Fri, Feb 06, 2026 at 09:09:40PM +0000, david.laight.linux@gmail.com wrote:
> > From: David Laight <david.laight.linux@gmail.com>
> > 
> > avg_array() is defined as a 'type independant' #define.
> > However the algorithm is only valid for unsigned types and the
> > implementation is only valid for u64.
> > All the callers pass temporary kmalloc() allocated arrays of u64.
> > 
> > Replace with a function that takes a pointer to a u64 array.
> > 
> > Change the implementation to sum the low and high 32bits of each
> > value separately and then compute the average.  
> Thanks David, this is a great optimization.
> 
> I also reviewed the algorithm and confirmed it is functionally equivalent
> to the previous version. I tested it on a platform with QAT and it
> behaves as expected.
> 
> Some minor comments below.
> 
> > This will be massively faster as it does two divisions rather than
> > one for each element.  
> NIT: probably not `massively faster` as the maximum value for len in the
> current implementation is 4.

It is still a lot faster - but probably not significant to system performance.

Actually if the max for len is 65536 you can do better (esp. for 32bit).
Instead of splitting 32/32 split 48/16, then sum_lo needs only be u32.

giving:

{
	u64 sum_hi = 0;
	u32 sum_lo = 0;
	size_t i;

	for (i = 0; i < len; i++) {
		sum_hi += array[i] >> 16;
		sum_lo += array[i] & 0xffff;
	}

	sum_lo += do_div(sum_hi, len) << 16;

	return (sum_hi << 16) + sum_lo / len;
}

OTOH aren't those values performance counts of some kind?
Adding four of them together isn't going to wrap.

> 
> > Also removes some very pointless __unqual_scalar_typeof().
> > They could be 'auto _x = 0 ? x + 0 : 0;' even if the types weren't fixed.
> > 
> > Only compile tested.
> > 
> > Signed-off-by: David Laight <david.laight.linux@gmail.com>
> > ---
> >  .../intel/qat/qat_common/adf_tl_debugfs.c     | 38 ++++++++-----------
> >  1 file changed, 15 insertions(+), 23 deletions(-)
> > 
> > diff --git a/drivers/crypto/intel/qat/qat_common/adf_tl_debugfs.c b/drivers/crypto/intel/qat/qat_common/adf_tl_debugfs.c
> > index b81f70576683..a084437a2631 100644
> > --- a/drivers/crypto/intel/qat/qat_common/adf_tl_debugfs.c
> > +++ b/drivers/crypto/intel/qat/qat_common/adf_tl_debugfs.c
> > @@ -77,32 +77,24 @@ static int tl_collect_values_u64(struct adf_telemetry *telemetry,
> >   * @len: Number of elements.
> >   *
> >   * This algorithm computes average of an array without running into overflow.
> > + * (Provided len is less than 2 << 31.)  
> Should this be 2^31 or 1 << 31?
> Alternatively: `Provided len fits in u32`?

Not sure why I wrote 2 << 31 :-)

The condition is that sum_lo must not overflow.
The worst case is all the low bits being 1.
If len is 2^32 then sum_lo is then (2^32 - 1) * 2^32.
The remainder from the sum_hi divide is shifted and added in,
giving (2^32 - 1) * (2^32 + 1) which is what my maths teacher called a
'cow and goat' - (cow + goat) * (cow - goat) = cow squared - goat squared,
so then maximum for sum_lo is 2^64 - 1 which fits.
Which means it should have been 'len <= 2^32'.

	David
 

> 
> >   *
> >   * Return: average of values.
> >   */
> > -#define avg_array(array, len) (				\
> > -{							\
> > -	typeof(&(array)[0]) _array = (array);		\
> > -	__unqual_scalar_typeof(_array[0]) _x = 0;	\
> > -	__unqual_scalar_typeof(_array[0]) _y = 0;	\
> > -	__unqual_scalar_typeof(_array[0]) _a, _b;	\
> > -	typeof(len) _len = (len);			\
> > -	size_t _i;					\
> > -							\
> > -	for (_i = 0; _i < _len; _i++) {			\
> > -		_a = _array[_i];			\
> > -		_b = do_div(_a, _len);			\
> > -		_x += _a;				\
> > -		if (_y >= _len - _b) {			\
> > -			_x++;				\
> > -			_y -= _len - _b;		\
> > -		} else {				\
> > -			_y += _b;			\
> > -		}					\
> > -	}						\
> > -	do_div(_y, _len);				\
> > -	(_x + _y);					\
> > -})
> > +static u64 avg_array(const u64 *array, size_t len)  
> Shall size_t len be u32 len?
> 
> > +{
> > +	u64 sum_hi = 0, sum_lo = 0;
> > +	size_t i;
> > +
> > +	for (i = 0; i < len; i++) {
> > +		sum_hi += array[i] >> 32;
> > +		sum_lo += (u32)array[i];
> > +	}
> > +
> > +	sum_lo += (u64)do_div(sum_hi, len) << 32;
> > +
> > +	return (sum_hi << 32) + div_u64(sum_lo, len);
> > +}
> >  
> >  /* Calculation function for simple counter. */
> >  static int tl_calc_count(struct adf_telemetry *telemetry,  
> 
> Thanks,
> 

