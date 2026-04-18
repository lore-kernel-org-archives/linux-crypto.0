Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22441A9B58
	for <linux-crypto@vger.kernel.org>; Sat, 18 Apr 2026 12:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776514302; cv=none; b=eKJIYLF1IzCzhSqWNFp4jl3DHS8e2jkhYfPbY3nhQz+3d68Tymsc8/xUB8fX9Oxns2eBrHfiXzO1ntVmbCitL7sgeapi1qKRXydiRSEJMl+KEPHmiZmtv+OXih+NsTOCBe/TfyOn0ElGoF1oU9fsjKqklN9MaBIrj63+j3eN7XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776514302; c=relaxed/simple;
	bh=3IMpqVTehU5fBs/5C0IiMz73ggjcJQ9kIjIUzNHZoL4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V6DJPkSoTdI6WY024vx/9UJZTB12v6MmLTWNoc1cnDSSE0xTna+DzAuUSVvBDkEGquwOrHdyYcMSY3o7HPrS6nuz8IiO9Voophas9OXe2bh4WMwIQOIlzhYCivN0XDLP8OpkHknIJrZYoiNCFnmg9b61kJM2i8BjyuxZAEHasYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Su5dyfSB; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=bqkSQHfl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Su5dyfSB";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="bqkSQHfl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776514299;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R2nMnTR8v0UWC8QSBtF5XWm7KZoT5rFuVXyMC3JV+oM=;
	b=Su5dyfSByIjNEqhAUQ/5ujOUSAu5YxC6BD8Jo9K0vekJxzpHv5p5zPT0GiYL7Ee+jln9Ny
	PkG9IbUzzgBMmCkuqf/DczuP018pyIc0nVwrHkc0Cfjh2YlaSUec8UKrjhajQ7grIP5wyp
	84eKq+pYS23E/M8tsdh54KTY7OAFHdQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-OMRtxTIgNXKIKx3WVsbuYg-1; Sat, 18 Apr 2026 08:11:38 -0400
X-MC-Unique: OMRtxTIgNXKIKx3WVsbuYg-1
X-Mimecast-MFC-AGG-ID: OMRtxTIgNXKIKx3WVsbuYg_1776514298
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-43d121c4271so1047170f8f.3
        for <linux-crypto@vger.kernel.org>; Sat, 18 Apr 2026 05:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1776514297; x=1777119097; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=R2nMnTR8v0UWC8QSBtF5XWm7KZoT5rFuVXyMC3JV+oM=;
        b=bqkSQHflbRqVGq0+JwulrJnCkkQSITrOZji3k3Mueorey9f2mFG1izwuC/J8tvyMr2
         PHmHXEQ9L+zlRpPaqrkUQO/OBx7DiyeyuffQh+ay1ezoSzX8WQlBidwyKYlKgn3USMsZ
         rddD3VyTWJ3vpPuVXv66menJeNjO46Bsdv2TIuchpibZuSuCRFEPQZkQ7HROgZ+DQsqF
         Wm+Z9XFjCsEEBvAeVPlT5f8enVjIGNYpuZ4fTsS3E0ugjwX1aDQLsYd/HxX0ivRDOEdN
         Fuqc3G5h54T8cVfQPYAesg9csX3vQ7nkK/lZS6GMWX7MRB033xzTfO65/kZnYnPEn4R0
         Bgtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776514297; x=1777119097;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R2nMnTR8v0UWC8QSBtF5XWm7KZoT5rFuVXyMC3JV+oM=;
        b=IEoxrpG4FUWWlIPnLwpGU7SjaoxkI0uGzEahI+eLSmstonhbWURj/PwfSfNpr0o2kg
         ult0t5oE2eGf/Pw6XtVOVZOr8C44KEXWiGSBLIFBhtR9gKwAILnmXlJ83WyKZwxzj1EL
         7tPHc6HLXhI5YC/X8YmIQ0LzH9XHMMXcRej8tipqmKdYuvCRFEYPIJXqHH0UcPY/PsX5
         h8P+q5Y3OhO4UJFWRq+KULBVq80zkQy3RSdAfrssM1unLL6ISbNq+nUz2fBY8CvWwLty
         5OU5RSPZ7Srfy2l5kBM1/sznFdjn6141VeBl1SuWPaFgGdRtJu43OapNZKFDUeiVMHoI
         O1Rg==
X-Forwarded-Encrypted: i=1; AFNElJ//vIq7D5Oh2lIV5UC32tf7HFLR9sM8Ep/BDZ5pR03HqIvNlyI0tGtd52Cjji+b29X/i4QULq1bh+SEb0Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YwooT4dOPhBKbvNti/p34ohDAnNl/AQcDYAjNzdmQQXQbIXXCaw
	Efc9ZrrkZnQQpD0jRCkkW8jpH+hwQ91dwvlTWLyTVcHzv3Hm2OVaCnybLGv7j9ybpE2axvYpB7k
	kCrHLRdo4yucsAAcBKcQGM6HbHkJyy5tj9ltohOyAWvTeWvMghpyN0bK+55s1BzrWVH0cmcZ9Ig
	==
X-Gm-Gg: AeBDiesP5AGkAHnLxHHLOQLQi6OXlbAgkChBQUfbxb5nTncLEOz0cG+79PJNiGeqCzM
	MCXWCX7xL+gSt/gdz2o57KJjDZ914WrhU2NvF20TB6lFH2YN0SFVKqVUKPQ9cpWe97XJncq94ii
	7gGvpMv8jDfFe3fnRumlBXkjYsITeh9EQgwEgjTEpS9he4E8gQC23AcJPmVQVaB7F7MWtIJ6f9B
	TaWCPdOslisbBtbbHEwIDw2pih1PCQenjm9bRR9RHjz9+LUwbJJ9KTEW0vP/39i6Q+bS9dPwtxl
	ombJ97z5paWQUVJBIVNln5IvKuXgdvLYMiEhiR6/wcazsXNkvOcUTHd+7Hjp+8vT3x9oF7SAJoh
	cuD72qmDutjp1kC2cNOfS01pNi2xZkptUNzSuvGMACxWsM1wv7rfLOg==
X-Received: by 2002:a05:6000:230b:b0:43d:7cb5:43b2 with SMTP id ffacd0b85a97d-43fe3db3150mr9934359f8f.15.1776514297248;
        Sat, 18 Apr 2026 05:11:37 -0700 (PDT)
X-Received: by 2002:a05:6000:230b:b0:43d:7cb5:43b2 with SMTP id ffacd0b85a97d-43fe3db3150mr9934293f8f.15.1776514296726;
        Sat, 18 Apr 2026 05:11:36 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4cb135asm14049130f8f.6.2026.04.18.05.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 05:11:36 -0700 (PDT)
Date: Sat, 18 Apr 2026 08:11:33 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jason Wang <jasowang@redhat.com>, virtualization@lists.linux.dev
Subject: Re: [PATCH] hwrng: virtio: reject invalid used.len from the device
Message-ID: <20260418080446-mutt-send-email-mst@kernel.org>
References: <20260418000020.1847122-1-michael.bommarito@gmail.com>
 <20260417201129-mutt-send-email-mst@kernel.org>
 <CAJJ9bXzhKTBx4m3-SCM+ccGd6ZhTXTAbRxKekCzidnXY6yXbWg@mail.gmail.com>
 <20260417202330-mutt-send-email-mst@kernel.org>
 <CAJJ9bXweZ2k+F5A7rOWSodzTN6UYOP3rf2oBbrVirOuof0tqNg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJJ9bXweZ2k+F5A7rOWSodzTN6UYOP3rf2oBbrVirOuof0tqNg@mail.gmail.com>

On Fri, Apr 17, 2026 at 08:47:09PM -0400, Michael Bommarito wrote:
> On Fri, Apr 17, 2026 at 8:31 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > Actionable meaning what?
> 
> Well, between the BLAKE2 pass and the fact that 99% of guests already
> shouldn't trust what's above, I agree that actionable doesn't mean
> much to most people, not even for breaking KASLR.
> 
> But after doing some research, I realized that SEV-SNP/TDX guests that
> expect lockdown=confidentiality might actually expect otherwise under
> that security model.  Still not a lot to work with, but more than just
> correctness in those cases, and those might be the environments that
> care the most.

Sorry this went over my head. We are talking about a device where guest
trusts host to feed it randomness, enabling it is already a questionable
enterprise for SEV-SNP/TDX. So what does it matter whether guest gets by
data from host directly or by tricking it into feeding its own data to
it?  It's all supposed to be securely mixed with the cpu rng, right?

I am not arguing we should not fix it, I am trying to figure out
the actual security impact.


> > Maybe clamp at sizeof(vi->data) then? 0 might break buggy devices that
> > were working earlier.
> > Or just clamp where it's used, for clarity.
> > And maybe we need the array_index dance, given
> > you are worried about malicious.
> 
> Happy to send a v2 with those changes but I can only test on a 1-2 TDX
> variants at home and don't have access to an EPYC bare metal box, so
> not very confident about your buggy device point


I am not sure why this matters.

-- 
MST

