Received: from mail186-20.suw21.mandrillapp.com (mail186-20.suw21.mandrillapp.com [198.2.186.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B9F31984C
	for <linux-crypto@vger.kernel.org>; Fri, 12 Dec 2025 10:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.2.186.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765534747; cv=none; b=GXjRDg64RF6wTyxOHmqI9qa7pn3/Zu7Rxq31JTreZvmaUnZlCZXns+nBRno3lEvU8pYmge3Yev4ncqFfth9dWTeodbY6d+0rmbT7eC6IwzfW2jxi3cO3wh/q8KOmaykHCsBn8hc0WHG4SjsFWdftDrXDu3X8tBBKyxM3KdahmQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765534747; c=relaxed/simple;
	bh=l9zKCV2yslm3kqZyRH27hTvQR4vlRU6gyly5D+xtdQc=;
	h=From:Subject:Message-Id:To:Cc:References:In-Reply-To:Date:
	 MIME-Version:Content-Type; b=NHpm20i0qj12Hk+SVOXuivLavXBldshNXjD5XEaCkoE4t5pSKhpRQ2O2i/Uv1XtXudZz/Qjk0Y6deiQ247/RKyPX4qJcFftnP4crcDC3mZz/4c4x+yIw6k32M93GDJlcvCft/FSNm9l+7xUte4kgAh4ilan+9dM/D2tuKxABXbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vates.tech; spf=pass smtp.mailfrom=bounce.vates.tech; dkim=pass (2048-bit key) header.d=mandrillapp.com header.i=@mandrillapp.com header.b=AEZmXPBK; dkim=pass (2048-bit key) header.d=vates.tech header.i=thomas.courrege@vates.tech header.b=pG0l6bf3; arc=none smtp.client-ip=198.2.186.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vates.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bounce.vates.tech
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mandrillapp.com header.i=@mandrillapp.com header.b="AEZmXPBK";
	dkim=pass (2048-bit key) header.d=vates.tech header.i=thomas.courrege@vates.tech header.b="pG0l6bf3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandrillapp.com;
	s=mte1; t=1765534744; x=1765804744;
	bh=l9zKCV2yslm3kqZyRH27hTvQR4vlRU6gyly5D+xtdQc=;
	h=From:Subject:Message-Id:To:Cc:References:In-Reply-To:Feedback-ID:
	 Date:MIME-Version:Content-Type:Content-Transfer-Encoding:CC:Date:
	 Subject:From;
	b=AEZmXPBKTSH1bbpvWr8TSXNG6Hmom6M2Qp5isNQViHyF/f2gIroCS5/UgJlCU/o6V
	 8PPamgOTSC1v5HB/roqUyP3dEQB8TDl5+gQiwNvbFLe4aj4BedbWX3+olFm8JUa8Qi
	 mewCQquh11OyJq2PHLH0cEz/+O/m21KzReb1WUQfGqj9SCDoBtrc0K1bkGZ7K/hXRf
	 qJ8rMoIHZKG0mDEbiFm6MmSbISsO/6E7pH8xePrs5P/3OK7t9cO8WytXyBdO6SmcX1
	 pmpc0EfFAVH5XJaPu/cNHLsd8+hfZF69nafrlJbUatWv+tbY4cc15wLZeoCpnhdINL
	 T93UADlh0rzBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vates.tech; s=mte1;
	t=1765534744; x=1765795244; i=thomas.courrege@vates.tech;
	bh=l9zKCV2yslm3kqZyRH27hTvQR4vlRU6gyly5D+xtdQc=;
	h=From:Subject:Message-Id:To:Cc:References:In-Reply-To:Feedback-ID:
	 Date:MIME-Version:Content-Type:Content-Transfer-Encoding:CC:Date:
	 Subject:From;
	b=pG0l6bf34yMMnnSp5G5+oIu8vB062t4yyEzBjNCvHztr5N6EdT7Om3RBX9CS31lq/
	 qO4A6Gxfqf/sQdgdE2oz32fcte33feqGDvtcK4OxUEqPZN8DWQ9esrexGnmQneIDN6
	 Lka3L8xjZ7FWYP9W3JRSJS7fPMSZp1NWKI49DMkKOrukSgXMG+b5/TwmcwqF60RcBz
	 THUZiEjw++tY5+zutsT8arfyMYwYJjl5iEJWpiFsuPpVwUaJKR88Xdx0kAlKmA+nlY
	 WoZLRZG1xMuCi42po+VAVZgYHW1ZQ151PUwLJ3RU2WJYHokP0Gt5E/Kf3sdgIU3/uB
	 sizHOfeMPeKRQ==
Received: from pmta10.mandrill.prod.suw01.rsglab.com (localhost [127.0.0.1])
	by mail186-20.suw21.mandrillapp.com (Mailchimp) with ESMTP id 4dSQRD4BnBzFCWsFK
	for <linux-crypto@vger.kernel.org>; Fri, 12 Dec 2025 10:19:04 +0000 (GMT)
From: "Thomas Courrege" <thomas.courrege@vates.tech>
Subject: =?utf-8?Q?Re:=20[PATCH=20v2]=20KVM:=20SEV:=20Add=20KVM=5FSEV=5FSNP=5FHV=5FREPORT=5FREQ=20command?=
Received: from [37.26.189.201] by mandrillapp.com id 659ffc3f895e44a98d1a7968970a007f; Fri, 12 Dec 2025 10:19:04 +0000
X-Bm-Milter-Handled: 4ffbd6c1-ee69-4e1b-aabd-f977039bd3e2
X-Bm-Transport-Timestamp: 1765534743899
Message-Id: <4fa34bbd-ca16-4f19-8822-d72297375c7d@vates.tech>
To: "Tom Lendacky" <thomas.lendacky@amd.com>, pbonzini@redhat.com, seanjc@google.com, corbet@lwn.net, ashish.kalra@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au, nikunj@amd.com
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20251201151940.172521-1-thomas.courrege@vates.tech> <30242a68-25f5-4e92-b776-f3eb6f137c31@amd.com> <85baa45b-0fb9-43fb-9f87-9b0036e08f56@vates.tech> <7b3c264c-03bb-4dc5-b5c6-24fb0bd179cf@amd.com>
In-Reply-To: <7b3c264c-03bb-4dc5-b5c6-24fb0bd179cf@amd.com>
X-Native-Encoded: 1
X-Report-Abuse: =?UTF-8?Q?Please=20forward=20a=20copy=20of=20this=20message,=20including=20all=20headers,=20to=20abuse@mandrill.com.=20You=20can=20also=20report=20abuse=20here:=20https://mandrillapp.com/contact/abuse=3Fid=3D30504962.659ffc3f895e44a98d1a7968970a007f?=
X-Mandrill-User: md_30504962
Feedback-ID: 30504962:30504962.20251212:md
Date: Fri, 12 Dec 2025 10:19:04 +0000
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


On 12/5/25 3:28 PM, Tom Lendacky wrote:
> On 12/4/25 07:21, Thomas Courrege wrote:
>> On 12/2/25 8:29 PM, Tom Lendacky wrote:
>>
>>>> +
>>>> +e_free_rsp:
>>>> +=09/* contains sensitive data */
>>>> +=09memzero_explicit(report_rsp, PAGE_SIZE);
>>> Does it? What is sensitive that needs to be cleared?
>> Combine with others reports, it could allow to do an inventory of the gu=
ests,
>> which ones share the same author, measurement, policy...
>> It is not needed, but generating a report is not a common operation so
>> performance is not an issue here. What do you think is the best to do ?
> Can't userspace do that just by generating/requesting reports? If there
> are no keys, IVs, secrets, etc. in the memory, I don't see what the
> memzero_explicit() is accomplishing. Maybe I'm missing something here and
> others may have different advice.
You're right, and there's no warranty the userspace will memzero the report
And the SEV report isn't memzero too

Thanks,=C2=A0
Thomas

