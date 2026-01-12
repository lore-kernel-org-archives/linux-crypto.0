Received: from mail137-3.atl71.mandrillapp.com (mail137-3.atl71.mandrillapp.com [198.2.137.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF74630EF72
	for <linux-crypto@vger.kernel.org>; Mon, 12 Jan 2026 08:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.2.137.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768205543; cv=none; b=o5KMSxq0UMVKSJ0iU0phOA52O046DgO8hRjAwy/uXnF74oNUQ09PfL2aUH4h1viZoJb7pGuDG00RDknE4AfFJRv1+RuSqWfAtJqPeVaFAeJsILKgbnp37q2K7S5vp9pFJbKyFHOue5Jw85/YmwZnrVGpOjeTe8CJQB/VNKc4O1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768205543; c=relaxed/simple;
	bh=keYa/bbbVNIONFLF2/By6XeO0uZvqCHaw1BMj3KZd3I=;
	h=From:Subject:To:Cc:Message-Id:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=ZAVFTUA7PrLBNweI1qx1Zne94xGBUKkKKx5kQITiON97Z/whoAPghXB/0+eyQcZkz1kmsPu3mpC7/PnHCgjQZ1zE1yr/b6hZwnc3cEAFamkCpanA1PzkXqCmKvvWXmJxM+7cHtYRDTnvOogJDbdEbb4cOb4EoVmCzuGqG3Aom7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vates.tech; spf=pass smtp.mailfrom=bounce.vates.tech; dkim=pass (2048-bit key) header.d=mandrillapp.com header.i=@mandrillapp.com header.b=wSjrWL5p; dkim=pass (2048-bit key) header.d=vates.tech header.i=thomas.courrege@vates.tech header.b=DSp7ktRe; arc=none smtp.client-ip=198.2.137.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vates.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bounce.vates.tech
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mandrillapp.com header.i=@mandrillapp.com header.b="wSjrWL5p";
	dkim=pass (2048-bit key) header.d=vates.tech header.i=thomas.courrege@vates.tech header.b="DSp7ktRe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandrillapp.com;
	s=mte1; t=1768205540; x=1768475540;
	bh=keYa/bbbVNIONFLF2/By6XeO0uZvqCHaw1BMj3KZd3I=;
	h=From:Subject:To:Cc:Message-Id:In-Reply-To:References:Feedback-ID:
	 Date:MIME-Version:Content-Type:Content-Transfer-Encoding:CC:Date:
	 Subject:From;
	b=wSjrWL5pdXb8D8oDNCg8pgRB0cKlbnCspkkEKEw3lou+X+P8jooMuAvsvBUVk+A5P
	 SoWOf2VOJprWBqdcJK7kUarTlRMRtTn7gNHkv7uA+SqbnP+z5smDxfVq1o/Fdh//+q
	 dRuDN0suHBPHaINuvDXrt0WxOEOWFAtPrDmlnkMJ30m+C9GPK1MjKSbfeaGfB+hjZ7
	 Phtbk0EO6qKy2OBuJEQlpMdPBDWaQ54fTGERCLX8xnRYVLRVjz4d/T7dvrOjxaiK5o
	 ui6BjAoslaCmMBE0N41P6IGQkFaY3hE4czriNfhqAolyRJSE3LzZ+vJfyyLe0BpvaC
	 Rt/f61xxDgGKg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vates.tech; s=mte1;
	t=1768205540; x=1768466040; i=thomas.courrege@vates.tech;
	bh=keYa/bbbVNIONFLF2/By6XeO0uZvqCHaw1BMj3KZd3I=;
	h=From:Subject:To:Cc:Message-Id:In-Reply-To:References:Feedback-ID:
	 Date:MIME-Version:Content-Type:Content-Transfer-Encoding:CC:Date:
	 Subject:From;
	b=DSp7ktRe/8Pv/1muyY/Xv+ltuECLXiE+lROYFM4BZVKDrk3qrGiRT5QFVZsUMvFA5
	 CoR5yGZhoH00m/GJd9kWNm0mFtvDsCac71S52t0oVbMYJVWmHXbnwARX7O4TH1KpYl
	 ZmOmhu3Z2+7VB3+d/WpVb7d3iRy2ZJSzWdHoQVY4mFVmzZJl8CZbv65ZzALuNZWlJl
	 ZWoCq85s85Nn7jJzDtJwPfSQcIUwTW/KTfuQrvtufOA9WseYH4Rg+KwsE4oYBWulq3
	 4naqX13U9yG364yDk79R0cdSQBH/VY1flq/srLxAzc77AuG3BkZlrdMcmsj2wRYv+8
	 RxEiBLaV6sSXQ==
Received: from pmta07.mandrill.prod.atl01.rsglab.com (localhost [127.0.0.1])
	by mail137-3.atl71.mandrillapp.com (Mailchimp) with ESMTP id 4dqQ8h3vQ8zBsVDvw
	for <linux-crypto@vger.kernel.org>; Mon, 12 Jan 2026 08:12:20 +0000 (GMT)
From: "Thomas Courrege" <thomas.courrege@vates.tech>
Subject: =?utf-8?Q?Re:=20[PATCH=20v3]=20KVM:=20SEV:=20Add=20KVM=5FSEV=5FSNP=5FHV=5FREPORT=5FREQ=20command?=
Received: from [37.26.189.201] by mandrillapp.com id b57a7266922d4657b6ecbcbd3b1d2e3a; Mon, 12 Jan 2026 08:12:20 +0000
X-Mailer: git-send-email 2.52.0
X-Bm-Milter-Handled: 4ffbd6c1-ee69-4e1b-aabd-f977039bd3e2
X-Bm-Transport-Timestamp: 1768205539240
To: thomas.courrege@vates.tech
Cc: ashish.kalra@amd.com, corbet@lwn.net, herbert@gondor.apana.org.au, john.allen@amd.com, kvm@vger.kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, nikunj@amd.com, pbonzini@redhat.com, seanjc@google.com, thomas.lendacky@amd.com, x86@kernel.org
Message-Id: <20260112081204.20368-1-thomas.courrege@vates.tech>
In-Reply-To: <20251215141417.2821412-1-thomas.courrege@vates.tech>
References: <20251215141417.2821412-1-thomas.courrege@vates.tech>
X-Native-Encoded: 1
X-Report-Abuse: =?UTF-8?Q?Please=20forward=20a=20copy=20of=20this=20message,=20including=20all=20headers,=20to=20abuse@mandrill.com.=20You=20can=20also=20report=20abuse=20here:=20https://mandrillapp.com/contact/abuse=3Fid=3D30504962.b57a7266922d4657b6ecbcbd3b1d2e3a?=
X-Mandrill-User: md_30504962
Feedback-ID: 30504962:30504962.20260112:md
Date: Mon, 12 Jan 2026 08:12:20 +0000
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Gentle ping.

Thanks,
Thomas
