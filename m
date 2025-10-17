Received: from mout.web.de (mout.web.de [212.227.15.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87565328B5F;
	Fri, 17 Oct 2025 11:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760699231; cv=none; b=SviucGxecueu7O6mZQbvXL/j2YWQ5BGWJ9/eLOJmWt4fqcGeUilMaozLQa8BbRF2ONLKiZFJaovfvWfDJpVeI5b/blUxkUw2nkkZ4akp26xbcoZ8ekdwkI5DWYP8ChIgoYjr1N0ahy9gJdXJZKJwLLMTEhwc4jjkBrq8d8DMh9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760699231; c=relaxed/simple;
	bh=YM1qJhiYW/aJM7mu78MMauGEvaYVNdHVJZF/56mG06A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z4kauBaFC5aK6CN0I+tqgEChB9QjzU6jTpffCbjE1zf0ZFFxLvgg0rtozRXDazvh2LY3zeIpjSWUS/gNcFzP9e0mjJyg5bS4DrQob7lQIscBQAk+Auv+878KAgqtRtv3Fg+ZO/ZbCcaOaDnmkH74T3B9IWOsKg3ddnLQOomPFEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=qwAL2V6b; arc=none smtp.client-ip=212.227.15.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="qwAL2V6b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760699200; x=1761304000; i=markus.elfring@web.de;
	bh=mBs//QP/LI/q0shbH30wWUG5UPKzyBqKbrx2NSC0/iA=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=qwAL2V6bkyx6cmydBafs8WZ0S0BOEVtckYXPJzlqKcsMU/uTEwFV8ffzv2njWc5y
	 +FVsqIN+ACzBv3T+qcNbzR+XcvdyGYB/lyvXO/kRPlyXWVGwe3nEMESRe2DF+tniA
	 XvEYuFTlnvA+XJE3BSzwhwShlqbYTFLQVTJklBwmdvTcNPJKHh3EUu9LDtsUy4m7/
	 yPu9o4c0YSKldWHx3WdsQCUgM4Rbsi6qfmEcGck4aj7MfS9mjroqy6hHct1UjTR0e
	 UIttH3UQY3j/gOnO6jusnUxBceGFD6V+VJKI3/iVCsxBDvEPGlt7CHTSkZ9KF51O7
	 bQAOj4oN15FQy6oPbQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.195]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1M9ISh-1v69nL1Bvb-0067bb; Fri, 17
 Oct 2025 13:06:40 +0200
Message-ID: <51baad8c-6997-4e3b-81df-6d0380fc48d0@web.de>
Date: Fri, 17 Oct 2025 13:06:27 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/4] Add SPAcc ahash support
To: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>,
 linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
Cc: Bhoomika Kadabi <bhoomikak@vayavyalabs.com>,
 Manjunath Hadli <manjunath.hadli@vayavyalabs.com>,
 Ruud Derwig <Ruud.Derwig@synopsys.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>,
 Aditya Kulkarni <adityak@vayavyalabs.com>, Conor Dooley
 <conor+dt@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 T Pratham <t-pratham@ti.com>
References: <20251007065020.495008-3-pavitrakumarm@vayavyalabs.com>
 <fe4d7cd9-0566-4d1b-97c0-91cc1f952077@web.de>
 <CALxtO0m1R0kf5Am+oEPAgqommQph9zs6+xfTM0GzGHV+YEXT3Q@mail.gmail.com>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <CALxtO0m1R0kf5Am+oEPAgqommQph9zs6+xfTM0GzGHV+YEXT3Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:DOUqFi5mKdhYzqNv9/13UKY+qECSIwj2ZbFzXXp7zmcukapKswf
 yXlhHpC+NyCtA0zfrD36QrmTHyx1n8cCfIHa25+hDYKRQL//E1UDXQqdBNFsFuj5Y2Fpvxy
 8mfDlLaCrLC3kL+YuVvXDwtpOxFgMX6SynxfXF7kgR60OZsjIroA9uG+4qBi+uXPMOHwKQR
 Q8zeuNt3gGPd8cXTqcBlg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:cRf46H0vaUY=;rhkQYmVCzYmb72mZbhYIBoGZV33
 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

>> =E2=80=A6
>>> +do_shash_err:
>>> +     crypto_free_shash(hash);
>>> +     kfree(sdesc);
>>> +
>>> +     return rc;
>>> +}
>> =E2=80=A6
>>
>> * You may use an additional label for better exception handling.
> PK: Ack, I will go with an additional label.

Can scope-based resource management become applicable for more use cases?

Regards,
Markus
