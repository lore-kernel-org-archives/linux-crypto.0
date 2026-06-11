Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A393D16FC
	for <linux-crypto@vger.kernel.org>; Thu, 11 Jun 2026 10:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781174585; cv=none; b=fkw1Zg/iVR4t6lUmhpvqKN7eDGzE867mwMakZafy/INuuQHRHBhgugctHyuG8lz2NxzxuGfU8BJCUgBmjzR3ucUgJZ9dkexItMurHnRrtG5LgDNGDit9+fn92MYwvSlJBJQB8EfWoEmYikznJSdxXw3xK05ZyAiVx28odBPCHj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781174585; c=relaxed/simple;
	bh=inQjxgWwPEtT4CnPw+fCJAJFNMKy78lOn5LXLW2oVNI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qg0iv5/YIRj5/cigQumK6jJvB4+R0OaYqgI/LChwGW1SvEjwnJYSe2YR8GpoF+J31l065Ct7pVJiZu9F+8acWP87i85JK5yRZufTmZt1ooBKqMx4njGexlT3sRv3bP5mb43gOoeKwHWMVPAtVIvC/I2OHuH+5C3yI4/DZyAHVI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dJtZ0Fcs; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=nsBT5VAW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dJtZ0Fcs";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="nsBT5VAW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781174583;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eTU8IEl2ECfz/odKayZYUlnGxNgbfPhvdxEP2MTzPP0=;
	b=dJtZ0Fcs5ZpJu6G+qm075Zl4ux/UpF8Xv5bvrrZ9uoE3J7h+aXl0E+q7GbDn+HHRSiFxsc
	yo0rZHyKkH8epkUaX5iw+PYYD43IsnKoohp16w5mYda4w5k0n7LJcqtcfqV18YZyGKpVgd
	Hun9q8dO2xgMWeIO/+HKHASbD0/sNrg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-480-IrfiFss0P9CkcWcjEZpAZA-1; Thu, 11 Jun 2026 06:43:02 -0400
X-MC-Unique: IrfiFss0P9CkcWcjEZpAZA-1
X-Mimecast-MFC-AGG-ID: IrfiFss0P9CkcWcjEZpAZA_1781174581
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-45efa2f7009so5149407f8f.3
        for <linux-crypto@vger.kernel.org>; Thu, 11 Jun 2026 03:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1781174581; x=1781779381; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eTU8IEl2ECfz/odKayZYUlnGxNgbfPhvdxEP2MTzPP0=;
        b=nsBT5VAWJ5oiWOOYPoFWrZXjs2TMwvOop8eFKcLjDQLdEHPm1648dE5xO3hUAZ32wA
         d4lr0BxlYDaNbWtOMffxXTJp8pXuVHt+X461/W/l9L3dNmsMOGlA1++p1JWIq6sa/ziE
         ffOOleoMgVMt5A65wwaO5vqRoCuX8Xz/zOTWxO6TXwKBg5oEo/lybxNc0Ss52quR8SwJ
         i8Vt/esFubiBoyBjq4DYvAmG3CWrfSVtfgUsZzcfjxeM8QWvr6c8d41CIWRAIsu7aaxK
         PU+a9NTNGu3Z6XT0dDW9VFxaPrBxQwiuiAnR5+j0QnWgI0UI6D7vEj7CWWvOqhTl8I3G
         RRyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781174581; x=1781779381;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eTU8IEl2ECfz/odKayZYUlnGxNgbfPhvdxEP2MTzPP0=;
        b=DzNyI9erUpWEDDveBW1qlKnOpZb4rRekDe2zCCz6/2/w0YtY+0AXJ8Ls+3XyOW7N27
         K6rn/9zabePLHlFILyD85OoT114aHYp3VKMODOHLYNPrtxACaaiecDNytAwAFa1ESrcG
         9+Hoc9k/An8yX40MbZetjlGOp2iVMC+jLJ0UvYXidGvJsYoYSXD/81kQKL4++4RewFl0
         snOCHVY/l95wl5w9Wj3Sk5uZafc91mTviAmr5e57eKX2N+AhcqrxLBy3DAtRjiRtSqaK
         qD5J6IW1yEAPAQqMgnB33JaXLAB1+EwMpaLPfmhb7Iq0aB4+zkADyzGygsCXwDunVYtV
         /DrQ==
X-Forwarded-Encrypted: i=1; AFNElJ+d3F8qXNXE7dxXrd+hP0qUrOdAObN/qOvYAjRC2i2oymnerWrcc4hG8HHLpZ9MbGB6F8QmpSqIsx2Nrms=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGfutytpwLw0Fh1o9mEQdiWXY8VeJSm5mUrLjlKjWhN4AFk2bE
	ih1U4BYPl4VICQpgDvD3f5BDyfC9E/BrwrgwGH8et6BD1/ic9S7MTsyf0VK/Vb1JnEByVtU7/Fo
	X/wO9+WRKnAEQ0xJGiJDn25TklwzuSCI7t3OfJkfOCBPr6WhZsqkY63+n9z3XQIRsKQ==
X-Gm-Gg: Acq92OEwyEYnPDO8lFLITb8qBnDwhdrTkYgrX9+9eJW45R49r24AR1WUcMXP2VaZUbI
	Mc/CVushv9OOZLslnkJhenYH+Egz7aGNV5UjFDySxlDdimVTFFMXzm5lYEM4VHRb6YsqAZZ5Acz
	UjdcxC0X7zYgS1LHGG/OBb8ZG8ylHN+dxFN6A5rYadzuGeJ0PGuvFZbeEj0VtrsCeOYSZQMEILx
	hf3ArCRN0s5B5ydGxKy+f77Y63xMvzDMh+MKh2U+4UIAUwFDwvBGC57rmfV33OYdYd1QpnVQcwh
	riLUin+gXMbBMFJ2IdJEMHPNAPGPJa4tvXyMfXG4yBCPom/NeR3TpH6eNNXUQKiur9w2/mSmQuj
	vNLYL06erGo0JL6UBZKH/+D4uBkNW7We8ZeYQ1RlPIkMU+8I8YBD8ag==
X-Received: by 2002:a05:600c:b96:b0:490:be14:bfda with SMTP id 5b1f17b1804b1-490e55baa3cmr26316995e9.6.1781174580789;
        Thu, 11 Jun 2026 03:43:00 -0700 (PDT)
X-Received: by 2002:a05:600c:b96:b0:490:be14:bfda with SMTP id 5b1f17b1804b1-490e55baa3cmr26316475e9.6.1781174580281;
        Thu, 11 Jun 2026 03:43:00 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f344762sm84495116f8f.23.2026.06.11.03.42.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 03:42:59 -0700 (PDT)
Date: Thu, 11 Jun 2026 06:42:56 -0400
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
Message-ID: <20260611064040-mutt-send-email-mst@kernel.org>
References: <20260531142251.2792061-1-michael.bommarito@gmail.com>
 <aio83ZWadVTiuNpR@gondor.apana.org.au>
 <20260611025916-mutt-send-email-mst@kernel.org>
 <aipn8sIAQ6Ai2sax@gondor.apana.org.au>
 <20260611035035-mutt-send-email-mst@kernel.org>
 <aipvZhfvdtRxOQm0@gondor.apana.org.au>
 <20260611050731-mutt-send-email-mst@kernel.org>
 <aip9nja-Oz2RxkWi@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aip9nja-Oz2RxkWi@gondor.apana.org.au>

On Thu, Jun 11, 2026 at 05:19:26PM +0800, Herbert Xu wrote:
> On Thu, Jun 11, 2026 at 05:10:32AM -0400, Michael S. Tsirkin wrote:
> >
> > data_avail is under hypervisor control
> > 
> >         avail = min_t(unsigned int, vi->data_avail, sizeof(vi->data));
> >         if (vi->data_idx >= avail) {
> >         	vi->data_idx = 0;
> > 
> > and maybe this can speculate past the if?
> > 
> > I agree, this is all speculation )
> 
> Either it is vulnerable to Spectre, or it isn't.  Adding nospec
> markers when you're not sure is cargo cult programming.

AKA defence is depth programming)
Alright we can drop this. No biggie.

-- 
MST

