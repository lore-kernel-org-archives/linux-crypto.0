Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CC5370AC8
	for <linux-crypto@vger.kernel.org>; Thu, 11 Jun 2026 07:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781164706; cv=none; b=UAK5kaAsFoBFwqreFl8u2Z7W0+Fmq2gOdKT7kPh7+sRyU/k9vXc2b2SmZVjqqHUiGn9l3FpafDjE7CA4jwC6M09T78dTS5J8GRFmHDRg4NEj4P1nVE4F76rAeeWTNl+p93hSGDE/2DpQL/iFSXgljV2f+aZRV8am3KTMItf1VeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781164706; c=relaxed/simple;
	bh=Bjyaxy6d6sDYB0cCMVeZFvsz5568RZUKEAaWTXKM5X0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CEU5XwJZnS0j7BnHmoahDRotRhHbtsPuIDwKU6xVy2Efvchml9GVh5t0TangpsQJDmBKydMmBRBrb78VraXQdoT5Tb4dfRFwIEpIkItdh2wIRjXqmPgqOGNNDYs31LlhzYOyKMFeYbR8mNw3T7hW22pHpCd8VCY07brLWNjcpLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jFkayUyf; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=WjjU4qZ1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jFkayUyf";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="WjjU4qZ1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781164704;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RPZeu4WL540NL3gNeV8fLdaGS7lC3tamuCeTPSZyTwA=;
	b=jFkayUyfK6/RF21IiqtiOuc3ECU89KeKmVI1nyEJgYii1PeMQdWHcGrwrY5HvXR++p1B56
	H3N1A4WNlkwcZP6hpknDSjZ9c064bkLcVPA2ScZfcJhP2av8kQd4+OmAQGeCdzRXs+M9pw
	accOZ1ush39yOlt+BEd0/9fP6sBOg88=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-397-6WYz6qaXMniOXiUyFAcBuQ-1; Thu, 11 Jun 2026 03:58:23 -0400
X-MC-Unique: 6WYz6qaXMniOXiUyFAcBuQ-1
X-Mimecast-MFC-AGG-ID: 6WYz6qaXMniOXiUyFAcBuQ_1781164702
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-490bfd70b0fso76799315e9.0
        for <linux-crypto@vger.kernel.org>; Thu, 11 Jun 2026 00:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1781164702; x=1781769502; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RPZeu4WL540NL3gNeV8fLdaGS7lC3tamuCeTPSZyTwA=;
        b=WjjU4qZ1kWsk0PF23cQWp2FEI8rM6sOTrKrFwoYF017fbPV8UAKCNQAEja+LhxKUkl
         TQANN0Web0ndXeIFWCq1qRg8QcXG6hF4xwr6b++xTODdLbwcDZg/9M1TY6cQ4DRU5oiG
         HEmD3mVDwiwVOK//IIeRlFAn8gKkRYyW8sEdNX0gyczkDfgokiHnWl+VERJEBX+/Jp8k
         eXc/2fcdz8j4kP8Y5s6ULgLv66G2cB0HjFZvahkoWfZVpdFbIEvejC8p2530G1BhUE67
         I+aTlHeBwgVUABRlkAdYlPRU6w7qp3EL1ch9ZZUfUxDkwRT3gerZtdKu4EBNx29HSi7X
         bFkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781164702; x=1781769502;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RPZeu4WL540NL3gNeV8fLdaGS7lC3tamuCeTPSZyTwA=;
        b=gpIH8QIL6oi4htF5+iovBR0pY6j0NgPxdkPXwoU/GA4/U+Lf/eNd+jERQfXLogUNhE
         XYarGhcfdzq02UoZcjcQtAw1uoACEZmcL+ZwNlCF8GONPzY6885Wtu/WOUh7JXkn1m83
         cOBiuXrUi7PjbI7Gt0F5MbJbSAszJEsiHZbgUbAa4F+w5n00f1xYeMp6buImQmAa9XlT
         LqE5R44eJlbnX6fJ98Yup8nIc1i+ofnM+xiK+YckLM9PWezmPJgtobzg6rN6erpgUkOY
         d8BZrGPJ2V5juyMfbsXsYjA3o6bsXbOrsVMH4C9yxBSEnGu0Rrx/w3Tqcu3wIQHI074S
         d+9Q==
X-Forwarded-Encrypted: i=1; AFNElJ/puouK1riu99Ywo5Q9EsbJ4AnpegDQGEzIR1nqNCAqQPiIneUaa1d7kzpWBIx4HrIMAkXcsNRLmgijCAs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEgNqgLTgWWcBvMLP2zvyZbbtWZDSiOSuiZKWMZkyfPjoF97hN
	2J/ONhr6jtTy7h+NTqZFLx3JcsMGMRP1tMgy0D/1kaZuD+17h8BulbfsXu2/fUkEjH6FmcKVVBv
	06sabU5iW5UyooGDIs9C1skDTek0eiC3kkrdAB/ePMhQJCWqKR3y3dLuR2H6+uSDQUQ==
X-Gm-Gg: Acq92OGyRMfXU6OaDRf02UUJc00GBDAwj6yWoJ/mIgpwS8/LTVyVcWlbXbeSPM2hdJ0
	SOvNlQaxvqoAjfHA202NGucoCvccx7YQ8+Q/3eaPPFG5K8JX3SFWAr7hIsdBT8Lh1OtIvNGE2H7
	2qDVPcS/dw7UKUjDU/c9btlYE+ui5kOiNxcYn/uuArcxET4z8+G8lN6C0jiEqGrhwvqQX8MBdOY
	vZqZ+y4XWAPtxXj4MIGjHS8Au/LrN+MBPQGL4yuYmPYqWSPHUxHOhl1cYLxlTLLYa9hu3N2lquf
	abVzVbxNna98x2yoeyWUTssB/g9cHmQxijt3BCA/O+OqE8+YWh54G2rv+gJxJGtURL4033fiGtD
	O5ODmJLYMrmqShzb9MolzxftoEESZZvvf+ysS8ljT/0836i64Cld3mw==
X-Received: by 2002:a05:600c:8b31:b0:490:bb3e:30b0 with SMTP id 5b1f17b1804b1-490e55dc1c0mr20745535e9.4.1781164702043;
        Thu, 11 Jun 2026 00:58:22 -0700 (PDT)
X-Received: by 2002:a05:600c:8b31:b0:490:bb3e:30b0 with SMTP id 5b1f17b1804b1-490e55dc1c0mr20745215e9.4.1781164701625;
        Thu, 11 Jun 2026 00:58:21 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2ec711sm76254621f8f.12.2026.06.11.00.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 00:58:21 -0700 (PDT)
Date: Thu, 11 Jun 2026 03:58:17 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Michael Bommarito <michael.bommarito@gmail.com>,
	Olivia Mackall <olivia@selenic.com>, linux-crypto@vger.kernel.org,
	Jason Wang <jasowang@redhat.com>, Kees Cook <kees@kernel.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org,
	Dan Williams <djbw@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>, torvalds@linux-foundation.org,
	alan@linux.intel.com, tglx@linutronix.de
Subject: Re: [PATCH v3] hwrng: virtio: clamp device-reported used.len at
 copy_data()
Message-ID: <20260611035035-mutt-send-email-mst@kernel.org>
References: <20260531142251.2792061-1-michael.bommarito@gmail.com>
 <aio83ZWadVTiuNpR@gondor.apana.org.au>
 <20260611025916-mutt-send-email-mst@kernel.org>
 <aipn8sIAQ6Ai2sax@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aipn8sIAQ6Ai2sax@gondor.apana.org.au>

On Thu, Jun 11, 2026 at 03:46:58PM +0800, Herbert Xu wrote:
> On Thu, Jun 11, 2026 at 03:30:14AM -0400, Michael S. Tsirkin wrote:
> > On Thu, Jun 11, 2026 at 12:43:09PM +0800, Herbert Xu wrote:
> > > On Sun, May 31, 2026 at 10:22:51AM -0400, Michael Bommarito wrote:
> > > >
> > > > +	size = min_t(unsigned int, size, avail - vi->data_idx);
> > > > +	idx = array_index_nospec(vi->data_idx, sizeof(vi->data));
> > > > +	memcpy(buf, vi->data + idx, size);
> > 
> > All the "malicious device" things are confusing. Spectre things -
> > doubly so.
> > 
> > So if an access is speculated then CPU might speculate feeding a kernel
> > secret into RNG. And then the speculated RNG value maybe can be also
> > speculatively be used by some kernel code as an index
> > to trigger a cache access, finally leaking the secret?
> > 
> > Maybe?
> 
> The way Spectre works is if you have an actual instruction using
> idx directly.  I don't see how that translates to memcpy.

I am not sure it has to be direct:

if (malicious_idx > SIZE)
	return;
src += malicious_idx;
memcpy(&value, src, ...)
....
hash = complex_hash_of(value)
....
return p[hash * 512];

is IIUC still a valid spectre v1 gadget leaking a value beyong SIZE, or
did I miss something?


And rng is a kind of a complex hash, but I also think in that "...."
in the kernel is probably large enough to close any transient execution
window.


So sure, we can drop this.




> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

