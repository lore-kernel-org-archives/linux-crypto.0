Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C45A346784
	for <linux-crypto@vger.kernel.org>; Sun,  1 Feb 2026 13:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769951275; cv=none; b=IjXrTHpMPUuzDohQL5ShG2tB1MnFufeGfJ9wlGrRpPGX9zr6v1pBv4xYHsMYC+kEpZodew9p9g1ZI+FXqtws/3MK0FFb9Z0dUTfJq81FChP91HZiHixYtbRYi7LGqWyy2TVcyFUxrJVhXu6vSq+/1WHiloHSkHA0+CteAgcThPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769951275; c=relaxed/simple;
	bh=Kwjp0+tVL9gMgYzKUXBYu1GRVe0BL1N/TmqXrs9Uwf4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rQ0ASKD/89quZyHimqPXvQeZ2JvQphjp5qOtSnjPnQFZyZdWybc9qHoQHkdGH9ntsh+3YPAvGrL9YoNvOHd+IKzMb33xdGdvUJVfheR/nZBk1UcQDrxyqd1Db7i5F2yOD/xNIKyP9IEGFMBWG5jCxMRVVMUwP9bP1SFMVSmrR48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=bVMWWEhE; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="bVMWWEhE"
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6119u89A1872200
	for <linux-crypto@vger.kernel.org>; Sun, 1 Feb 2026 05:07:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=AkESveN7TgNqfMbvTOPgaDQqBlCntqg8iMdsdi3eFAU=; b=bVMWWEhEBxjE
	rUsPm27UoRCcx5AZ/bRG459qP5Pnw1Y7+JxmIfL1TXw00qAb0J9m2rxQQ1rAYjJX
	4B8uSNXXLMn4zsXoA75cRxaQJDI5WXa4QoGY2tc+plUmiDFZ8FTtnUjmrXBJ0sDN
	Wv4WvghZpEXzsJMVwVLKPJWXEovYte34aVtvqq0yvKBtAikOoZ85/XhJ7UnaNm9/
	EIdeibhpzArPbbxeq/1sCEcKDg6AFXOa1ZvJTNNAkRusnLgvQfS/BOPl7vsh0tAi
	KHtHEiA4MVuF2x+SZ+GiH47jBQAkINale3q7yuX11flD16MV56OM8Th1fSF8cFz0
	pPsoKVXfRg==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4c1gbeyef5-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Sun, 01 Feb 2026 05:07:53 -0800 (PST)
Received: from twshared41309.15.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.35; Sun, 1 Feb 2026 13:07:49 +0000
Received: by devbig010.atn3.facebook.com (Postfix, from userid 224791)
	id 559387B1FB6; Sun,  1 Feb 2026 05:07:38 -0800 (PST)
Date: Sun, 1 Feb 2026 05:07:38 -0800
From: Daniel Hodges <hodgesd@meta.com>
To: Ignat Korchagin <ignat@cloudflare.com>
CC: Eric Biggers <ebiggers@kernel.org>, David Howells <dhowells@redhat.com>,
        Lukas Wunner <lukas@wunner.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>, <keyrings@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: pkcs7 - use constant-time digest comparison
Message-ID: <aX9P2Y4AUuetwIPF@fb.com>
References: <20260201035503.3945067-1-hodgesd@meta.com>
 <20260201044135.GA71244@quark>
 <CALrw=nG0Pj1W-bZ6qQax0WnxSayCtYx97ivRuQMsVZHbsQZong@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <CALrw=nG0Pj1W-bZ6qQax0WnxSayCtYx97ivRuQMsVZHbsQZong@mail.gmail.com>
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
X-Proofpoint-ORIG-GUID: FXmwWZVdDT6Sk4qFjvpKnn_Xblfa03Vi
X-Authority-Analysis: v=2.4 cv=Ja+xbEKV c=1 sm=1 tr=0 ts=697f5029 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=-oXVGbNiZCuEa3XDEhEA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAxMDExNCBTYWx0ZWRfXx9bXB6/QP6wF
 GH8RWwuU8aN4swloQOmP+HDwtiFwbf0Z/DpuCqlyc3e7GwnbRQkP1NX0ByXYHtQ2076SPvGXVVx
 y9Xcp9bAlLDf8Uow9tt50CYgzSDnbHOEds1dbS1Ush+rXF0YC85KMi9XVSCOEVj5IrCNmafr5sj
 BRQlt3VV/r7nxNZ0WookNzmYi9m5h2zcDxc0u+e4m8BiuwaVBigZjejffXSfWP9rHc64p4Tynhj
 KOiCnuHYTFa8b+0254dK373RLmr4tQQ9wizjNTapkyOJf1PqPjFB1U2ooUfoerO20xgJkRCqQCC
 +JpNNdBLR7Oj3L2+ZvFULxxay32CjL0xuxUH6vC1YsvWi9dU+KKm5t2F2Rko5A0Dpt91Q1/XB4k
 HDCb8fw5JhkxD+y6OmonXgmaSF0LDamP3azCc2VhlWedNET/S5Sq4KJqItSWn/T50LaJlXN8Fd2
 NtHxz+afNMjeFSr69+Q==
X-Proofpoint-GUID: FXmwWZVdDT6Sk4qFjvpKnn_Xblfa03Vi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-01_04,2026-01-30_04,2025-10-01_01

On Sun, Feb 01, 2026 at 11:55:26AM +0100, Ignat Korchagin wrote:
> On Sun, Feb 1, 2026 at 5:41=E2=80=AFAM Eric Biggers <ebiggers@kernel.or=
g> wrote:
> >
> > On Sat, Jan 31, 2026 at 07:55:03PM -0800, Daniel Hodges wrote:
> > > This creates a timing side-channel that could allow an
> > > attacker to forge valid signatures by measuring verification time
> > > and recovering the expected digest value byte-by-byte.
> >
> > Good luck with that.  The memcmp just checks that the CMS object
> > includes the hash of the data as a signed attribute.  It's a consiste=
ncy
> > check of two attacker-controlled values, which happens before the rea=
l
> > signature check.  You may be confusing it with a MAC comparison.
>=20
> On top of that the CMS object and the hash inside is "public", so even
> if you have state-of-the-art quantum computer thing you can just take
> the object and forge the signature "offline"
>=20
> > - Eric

I just went through the code flow again and that makes sense, sorry
about that!
