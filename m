Received: from mail132-20.atl131.mandrillapp.com (mail132-20.atl131.mandrillapp.com [198.2.132.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36D9341072
	for <linux-crypto@vger.kernel.org>; Thu,  4 Dec 2025 13:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.2.132.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764854512; cv=none; b=IAVhkI894OWtIAokYEdQzRsojYzRb+6oShtL01ucbZbjNSC9qwHnoRk4Dym8nAy1+p/XSlTzRkfVB4MHfcz7QzH8YzKFMXB6nb6iqoxNYoEzszVrAFp7rO6u8sW0QHh0MjANl3saFgjHNE4pjcBbJbYB23eOwIwZoULP75q8FKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764854512; c=relaxed/simple;
	bh=l1zpHWlZIk8v4kklrfJoj2bNMah8TNBHN/gHU2C/bR4=;
	h=From:Subject:Message-Id:To:Cc:References:In-Reply-To:Date:
	 MIME-Version:Content-Type; b=gbExhhtJLi+e7DWD5mstNxWWzLRXQreec33K91pAzPQEj6KbUmsO0WhThT6bxEGe+KLsE0YIzhVqHxEMdLSBG1e+3NSWQxSz1mhE50dL0Yf31voSJVSzDhqzt3NaA2hqKXLXWH3Gg3llmwyVB3McuNmUa58QWnb3KKiDib4s7oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vates.tech; spf=pass smtp.mailfrom=bounce.vates.tech; dkim=pass (2048-bit key) header.d=mandrillapp.com header.i=@mandrillapp.com header.b=rmd/tL3E; dkim=pass (2048-bit key) header.d=vates.tech header.i=thomas.courrege@vates.tech header.b=FadU6RLE; arc=none smtp.client-ip=198.2.132.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vates.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bounce.vates.tech
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mandrillapp.com header.i=@mandrillapp.com header.b="rmd/tL3E";
	dkim=pass (2048-bit key) header.d=vates.tech header.i=thomas.courrege@vates.tech header.b="FadU6RLE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandrillapp.com;
	s=mte1; t=1764854509; x=1765124509;
	bh=zPGLgI2YEBNoVTVWQEvF7b9V1uJmU+fj5TGVDfV1Cis=;
	h=From:Subject:Message-Id:To:Cc:References:In-Reply-To:Feedback-ID:
	 Date:MIME-Version:Content-Type:Content-Transfer-Encoding:CC:Date:
	 Subject:From;
	b=rmd/tL3E8azJaf094JCd8rBTtF9L4vKDVAE6nbWBKrXN/RvKzqsxdXfKSbMDuP/cj
	 t8Ue88iPTdBsr6Iv4KRteYX1J3os3cKggXOHk1uiIhZG5s8EIBZFw0RfCVyLJ7mmAq
	 2tV2SWRipH06hB4XtXNohfm4r+kMMFQJG42zkXzjXcortKwaWzzsIOZyeTd+bEsPDC
	 sGOH/ysmuQfqXaSkHkDNCTxOfTT92ilBYDRizSd4ANIBXjhW7Zs+QRs9ZCV1o3Xexx
	 x/mniJaygp5HhGiEVBD6UJB6b4aXlHvwsQRnfVxJ3vclh8QuQcFj4VPfZ/zG0jq12q
	 d7k/Wt9UP5pYQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vates.tech; s=mte1;
	t=1764854509; x=1765115009; i=thomas.courrege@vates.tech;
	bh=zPGLgI2YEBNoVTVWQEvF7b9V1uJmU+fj5TGVDfV1Cis=;
	h=From:Subject:Message-Id:To:Cc:References:In-Reply-To:Feedback-ID:
	 Date:MIME-Version:Content-Type:Content-Transfer-Encoding:CC:Date:
	 Subject:From;
	b=FadU6RLEGjTazgRMfuMBu4rxNtWQHVl03ZMRFPt+lwCNHGRDF40A4Cg8wjr9TEMRU
	 yURo6jUO7orbmrjm33TXM9TVhcngiPo3a9+46kY7D7E2rnC1Mej9EvyN3eMwTt3kML
	 fyjdUogE28aIzonHAwe8VBQ29P97L7H47a7a7hhEoyKGpKsQrrmce6GNHnaZ/eHATU
	 96enrfk17fWw0aStteMDtMXgLN2wjXQff4LxWJiFW+gL2B00TQVRKHqcR1IqKDYadz
	 yKotJPBKw1eG8fX6Rl0wo7A+FQl/Nc8sYPxfaJEFXGrFudlZW6XrVp34ObpgHmfM5J
	 Oe0WbIlDXi3tw==
Received: from pmta09.mandrill.prod.atl01.rsglab.com (localhost [127.0.0.1])
	by mail132-20.atl131.mandrillapp.com (Mailchimp) with ESMTP id 4dMZsn5PFTzFCWk9C
	for <linux-crypto@vger.kernel.org>; Thu,  4 Dec 2025 13:21:49 +0000 (GMT)
From: "Thomas Courrege" <thomas.courrege@vates.tech>
Subject: =?utf-8?Q?Re:=20[PATCH=20v2]=20KVM:=20SEV:=20Add=20KVM=5FSEV=5FSNP=5FHV=5FREPORT=5FREQ=20command?=
Received: from [37.26.189.201] by mandrillapp.com id dcae6667b6cb4b1bac96ee61264d2aa5; Thu, 04 Dec 2025 13:21:49 +0000
X-Bm-Milter-Handled: 4ffbd6c1-ee69-4e1b-aabd-f977039bd3e2
X-Bm-Transport-Timestamp: 1764854509149
Message-Id: <85baa45b-0fb9-43fb-9f87-9b0036e08f56@vates.tech>
To: "Tom Lendacky" <thomas.lendacky@amd.com>, pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, ashish.kalra@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au, nikunj@amd.com
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20251201151940.172521-1-thomas.courrege@vates.tech> <30242a68-25f5-4e92-b776-f3eb6f137c31@amd.com>
In-Reply-To: <30242a68-25f5-4e92-b776-f3eb6f137c31@amd.com>
X-Native-Encoded: 1
X-Report-Abuse: =?UTF-8?Q?Please=20forward=20a=20copy=20of=20this=20message,=20including=20all=20headers,=20to=20abuse@mandrill.com.=20You=20can=20also=20report=20abuse=20here:=20https://mandrillapp.com/contact/abuse=3Fid=3D30504962.dcae6667b6cb4b1bac96ee61264d2aa5?=
X-Mandrill-User: md_30504962
Feedback-ID: 30504962:30504962.20251204:md
Date: Thu, 04 Dec 2025 13:21:49 +0000
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 12/2/25 8:29 PM, Tom Lendacky wrote:

>> +
>> +e_free_rsp:
>> +	/* contains sensitive data */
>> +	memzero_explicit(report_rsp, PAGE_SIZE);
> Does it? What is sensitive that needs to be cleared?

Combine with others reports, it could allow to do an inventory of the guests,
which ones share the same author, measurement, policy...
It is not needed, but generating a report is not a common operation so
performance is not an issue here. What do you think is the best to do ?

Regards,
Thomas
