Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877423515D7;
	Sat, 26 Sep 2026 20:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790453887; cv=none; b=iHuCSHobAPXf8pYVbKpYcRv+zW1s43Ylhs8SO6U5pZ5mOadKyIOXIer9DwmD7mo37NfBiV2G1FhlmkjrisY3uFOCoRQekzNpmeW3Jr2T9Ie+Rlp8262Fk2STQnGYbMoaNUHUbVQr8MtI3O+iQoiF0H+Ar+sdRmCIB/YOMGD22aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790453887; c=relaxed/simple;
	bh=cMPIx83xGeJHwh537+ZmkoMhqHj0AHKD0xEdNxlT8TY=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=GSj6TU4KPj/G4eMvsVxQZheb831H/olu2j+3nCdB11hNbjf1v9GnDJsJyjIc0ltb9OXjgW31N6eWRwEqZavKZCR+V+nGUT59fGCW6XTyJnoQO+A4T2bB7OX+arlgEflxHmDOjNRpbW0fH+zW9vS0q4vn8+pQmwmWZCQvN1xKgQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=EDhpoG7v; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="EDhpoG7v"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	Message-ID:References:In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:
	Reply-To:Sender:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=GT/IbKfZEkygAriTq5cxZN3eZBPN9ViphrzqUeFcjVE=; b=EDhpoG7vaG40SjoanO27E9K9TL
	tssIHEebz1Lw/ZVFm5YJRbQOpx+JHmCjBoAOd4ZaCftRMmRwOv5kQXLcbYYlvZYI5AZyI3zXzgRFG
	LGOMzTF83RN+g5w3496Y9A9Ku3fPqJTfSu6LUA8PJQOlPP1FkJjvNbNciBcwHk5j8dRIouVc/CgNC
	92vuTEQCNDvE9DNdBZZhQs/p03GpI6ADdjUrj2nhQZ7RBuDC2YunWcbk+T/RMw0UdU3f+fiLqDKhg
	n0LVMPuxwTlxwnXmJqhz2IcVvJVpTfDvBlVxmUSb1iGBTYgmABQz2TafW+zlCbMFIL+v7OHF5fzoP
	PindA5fA==;
Received: from [::1] (port=44806 helo=pf-012.whm.fr-par.scw.cloud)
	by pf-012.whm.fr-par.scw.cloud with esmtpa (Exim 4.100.1)
	(envelope-from <jeremy.jean@oss.cyber.gouv.fr>)
	id 1xAYqT-00000000xu1-16cX;
	Sat, 26 Sep 2026 22:18:03 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sat, 26 Sep 2026 22:18:01 +0200
From: =?UTF-8?Q?J=C3=A9r=C3=A9my_Jean?= <jeremy.jean@oss.cyber.gouv.fr>
To: Ignat Korchagin <ignat@linux.win>
Cc: Lukas Wunner <lukas@wunner.de>, Stefan Berger <stefanb@linux.ibm.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
 <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ecc - Handle exceptional points in Shamir
 multiplication
In-Reply-To: <CAOs+rJWUi+Lr-G9NcOzStqPQyCG_L8HC2ZTa6QZBTGD+AAQKSA@mail.gmail.com>
References: <20260925132223.706291-2-Jeremy.Jean@oss.cyber.gouv.fr>
 <CAOs+rJWUi+Lr-G9NcOzStqPQyCG_L8HC2ZTa6QZBTGD+AAQKSA@mail.gmail.com>
User-Agent: Roundcube Webmail/1.6.19
Message-ID: <941ea3bacafb6c6dcc0edfe96a3f3fcd@oss.cyber.gouv.fr>
X-Sender: jeremy.jean@oss.cyber.gouv.fr
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 

On 2026-09-26 16:17, Ignat Korchagin wrote:
> On Fri, Sep 25, 2026 at 2:23 PM Jérémy Jean
> <Jeremy.Jean@oss.cyber.gouv.fr> wrote:
>> 
>> Shamir multiplication mishandles equal points, opposite points and the
>> point at infinity. This rejects valid ECDSA signatures and can accept
>> invalid digest/signature tuples when the public key is G or -G. The
> 
> Can you provide/construct test vectors for these? The ones that were
> accepted, but should fail.

Hello Ignat,

Thanks for the answer.
Good idea, I will add some in a v2.

Jérémy
