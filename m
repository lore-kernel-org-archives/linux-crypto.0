Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965BB342CBA
	for <linux-crypto@vger.kernel.org>; Tue,  3 Feb 2026 13:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770126332; cv=none; b=dtWFXukrJ1Z9tuY7vhCnt+B6juTPB4f+ZElGFhAYRNtUpzKLzqSljwmYTmaROVZPWfpMYz/eLVPYANBLhxQKh3w8CZTuVO2TcKrRPdRn9/qxbXIpa8nylYxSL2GHafWAwL4ZN2DBGXb3ZBtWXEx6UIUZZSNW3j4Lx/qMJTuvGTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770126332; c=relaxed/simple;
	bh=lvsYp3H1+gWA5AeRRPJ0wwKeu6rWLpQuDQcZLr3Mi9w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lUyEawRF933iQX0SZZyQ9/7koONO0dje0m9N5KPof6l4PNZ8mJ3qh+WWD1ev/FAwCBCuLL2g655M0ctbu3fJ6huGGzAlwaozGvjkyiK4TVbYfD9ExZgNgUNs4S0Da/ixsJRuCLFmxs8jJheCO5963GfDeGhh0d2WQXnSt7IVSu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=inAvxD4I; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=rqu5iPlQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="inAvxD4I";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="rqu5iPlQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770126328;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xr4CwAN4WPxPbrE6dktzcw7EThzmA9unHQ46Jjzl26E=;
	b=inAvxD4II958xy7wvAEb8srkRplbvEHHSqnZATYyn62UP+7zxwYkENwT5PkgeZyDQSgh/W
	dR9nPXLXj/EW81HqiNhkynYzc3tMUtFMDPM25Tj36XZqjHaR3S/OSmVCntqDxyBjnM3fLl
	95uYAc/aMC9fT0l8cmDDVhBKu1P/fwc=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-513-YKUvuR-mMxqRbwN9HpimkQ-1; Tue, 03 Feb 2026 08:45:27 -0500
X-MC-Unique: YKUvuR-mMxqRbwN9HpimkQ-1
X-Mimecast-MFC-AGG-ID: YKUvuR-mMxqRbwN9HpimkQ_1770126326
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-81f2481ab87so5334806b3a.0
        for <linux-crypto@vger.kernel.org>; Tue, 03 Feb 2026 05:45:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770126326; x=1770731126; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xr4CwAN4WPxPbrE6dktzcw7EThzmA9unHQ46Jjzl26E=;
        b=rqu5iPlQNeZgfwkBgBcPl4OqyrxTj0B4Xh7XrAAttNb6f+0RzlZAtDqqCSK+tQ7hcI
         5EITxg0JLEkhOf+NmgHWfL+wmT019Pjh+A6wtS0d/J35asq2Y932SovoY9gUguv3C338
         eglppUcTPR/0QWwvAtYFfJTXvVmFpIm6pXYdMLs6fsu1Ig8vU7Md9LHgtkecnXS31thx
         6a2bC3jlxG1fojxOazrh1vC7POzNIBjj9//GDFdbQH8TjIFwk9F670yKevh4wEi8XLF6
         rogfyDELwhiqJYm3Fedy7CUcL1GeZXGQMKe/h6RK7KatQMwjwWecvvgYicVoOy9SwgF4
         UEfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770126326; x=1770731126;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xr4CwAN4WPxPbrE6dktzcw7EThzmA9unHQ46Jjzl26E=;
        b=VrLuBxnKRPGWFREp4/FpQu0lqvvupIO1n2p3A5R5949KKAvc86Px7QldhI2TC78+W9
         6S+59gi8z4vWur4pbCdQl6VRelCPXls0eDzPOrmHQYBh/wp71zeuWsIdxtTAlyWFqrHY
         nzKRFDLn/qUUKzKbLWwZTxn61SaMnLVZNmQmFnAc/U1mSqs8C/tc+7ErJib6dJ1LqSAc
         hipZeHP0ZEpdx0cxE0MPAchNIH0YkPfQTvzuvrgRkF7+XTOst9SzbuW+ISXCY8VM+cMJ
         wVbBbvsP31sEpAfyY6QELboyK4MVs7WBT5qFlzxMfMy2W1dCDLzUmTJZ9r2BwJKyFXuV
         4HEQ==
X-Forwarded-Encrypted: i=1; AJvYcCXZj1WunAVqQ3Izb5VCkIO3hFbj9dLvE4NKn2YtLZFPyjdehiqzGiHyRT4aaYUWVAcIBRFCv2naW0nTIFs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGgwHqY2bdAuAfyN4CVqn6tc9nZu2Uh6wY4Hs1nKliimSMAmRL
	v9DI7RhybKBNsE6Owy871/oiJ+uouPXQEGYGI06I6q4Sf9uqCQw93dQwSqD0jEk+F/rquiSYzBT
	uZZMruy/2BJnZ7EC9lSA3xLF4lxlCY243hGd1Ph9X5ZmcSafQEjy/42SPfRyfpM4wlQ==
X-Gm-Gg: AZuq6aIuFbMZ7MY2yyXTSoIeRREypmouuhiGs6io8ceREimaeRmYpjNahVmsvwVytdk
	AKcR+AEs994RzIrwHI+gHaIhGYECIiE6bY+QTeohmj1uNRI2unOahvOeltXUiJIqW8l+p3E8Dky
	1/Lju0PiiDnzZ3Y1STwDyQswdC8Ki1QGe93DE+gSZOWwHFrh/1jcwzmdS+WNJlqwMOydTMEvvoQ
	00GFWjxdtZ7uWelTRevtBICTdvRFbMRnllA8GjmLmMNTDGDnI/+PidmSXUX6cVFS4WuZ30mAoJt
	YMjzKGyeRTesJWg57e97+SvEHZaaj7EdbWby9HBxdOKTuXk5jagLEplGWRLRKoqqaY2KjU4CMC6
	F
X-Received: by 2002:a05:6a00:9a8:b0:823:b5e:d0 with SMTP id d2e1a72fcca58-823aa7107a0mr14629535b3a.39.1770126325862;
        Tue, 03 Feb 2026 05:45:25 -0800 (PST)
X-Received: by 2002:a05:6a00:9a8:b0:823:b5e:d0 with SMTP id d2e1a72fcca58-823aa7107a0mr14629501b3a.39.1770126325332;
        Tue, 03 Feb 2026 05:45:25 -0800 (PST)
Received: from localhost ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82379bfc72asm24284818b3a.42.2026.02.03.05.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Feb 2026 05:45:24 -0800 (PST)
Date: Tue, 3 Feb 2026 21:43:03 +0800
From: Coiby Xu <coxu@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>, Simo Sorce <simo@redhat.com>, 
	Roberto Sassu <roberto.sassu@huawei.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
	Eric Snowberg <eric.snowberg@oracle.com>, Eric Biggers <ebiggers@kernel.org>, 
	linux-integrity@vger.kernel.org, linux-crypto@vger.kernel.org, keyrings@vger.kernel.org, 
	linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: IMA and PQC
Message-ID: <aYH5AlnUIv9MPRiY@Rk>
References: <aXrKaTem9nnWNuGV@Rk>
 <1783975.1769190197@warthog.procyon.org.uk>
 <2265997.1769782221@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <2265997.1769782221@warthog.procyon.org.uk>

On Fri, Jan 30, 2026 at 02:10:21PM +0000, David Howells wrote:
>Coiby Xu <coxu@redhat.com> wrote:
>
>> Take latest fresh CentOS Stream 10 x86_64 KVM guest as example, without any
>> file system optimization, extra ~189MB disk space is needed if all files in
>> /usr signed using by ML-DSA-65 where the disk size is 50G.
>
>Is that storing raw signatures rather than PKCS#7 wrapped signatures?

Yes, it's storing raw signatures + per ~20 bytes overhead including the
4-byte key ID.

>
>David
>

-- 
Best regards,
Coiby

