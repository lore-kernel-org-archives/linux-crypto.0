Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DABEEB3;
	Sat, 12 Oct 2024 15:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728745262; cv=none; b=fyuttO5g19KwEcKe41Yq+dRhAD4oHqx4W14aeS1PU9gycjNyoqQBTrp2Q31OCwQ79aL2vuKAIDKOhDNMJncrXjcNByIHRz/ElKo/6ZDK5ByAmeBbZewoJjl/nc0sYKHWxXVRxbtKpBJJ3OUuiXOstLyD1Y9tx+jkPg16tZUU7Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728745262; c=relaxed/simple;
	bh=JKfmqF9liqzzy2iYpeKbDBgsoMcjKO0fNtphf9lzs+s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DIRWDKByZnIex1tzBzZiWd3ITzoVhuxf+PTj7UzJ3qOOwPju1qP3KZJKFHF6Nehq7EygpPgxY2WiXxKVMHdj4/trPP1JEiQscyEuaeu+fXrG8YaThMm25kWckser7MSJXznoFy1g3NLkF8ugykfk7/4ri5NGWFlAMXFLtPKJzPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=Y6/o8Peo; arc=none smtp.client-ip=217.72.192.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="Y6/o8Peo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1728745228; x=1729350028; i=markus.elfring@web.de;
	bh=X0kQaLCXNNFr7S3GcaSa1PHybmMltmCt0iklqZF7ttE=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Y6/o8PeoTUgmaRqlqkY3dB9pa2jDjpmcXuD0etD8OHLbYEQe+u92Dp8D1nQ/ZQE9
	 qFWljPWNoXpdT06Q+wF6EG6yP042VO/DQVZO+wy9hWCG7oXHjp4yBQAuebkBzntD6
	 ewCx+7JRQXsXVtZOMIniME9e+L5780JHkTbsyFCNV97ilrA/Q+63M/Z+Tki1eWsiA
	 aYfmngqtWlqR+L5+NMdn89qr3F3JiUqRAHNwcYVpL2YoypDWTL+hl4CkeHmEM3ONu
	 HdxPghtwzaYyagjQqpgTzOWJOHP6O21FaiLlFplhiRohgMVncK7V8M2UMsgzmHZvE
	 NBieW/W7LLHgVxHrIA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.89.95]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MadzU-1tVwDR47R4-00aTok; Sat, 12
 Oct 2024 17:00:28 +0200
Message-ID: <ee5f409e-4412-41cd-b8d8-92872770f04d@web.de>
Date: Sat, 12 Oct 2024 17:00:26 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH v3 0/3] lib: Extending support for scope-based resource
 management
To: linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
References: <bc5ce9ad-acbd-4f3b-91d6-10cf62bf5afc@web.de>
 <202409180725.ZV8DCvII-lkp@intel.com>
 <91d10516-4ba9-4fe0-8f63-86205cc4f88c@web.de>
 <ZwDPp4bU1J5uEgQe@gondor.apana.org.au>
 <9ddc71e7-e98a-4fa8-b140-4035dd2874b6@web.de>
 <ZweTCO8cFtP_pvOu@gondor.apana.org.au>
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <ZweTCO8cFtP_pvOu@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:04x1Qu41RKT6NrhjVRibY1avpWcRN9Pu9Z3/w2xVBhJ3tfLQcXh
 9AnX1SEWF+sQANcWwvdXJruwbIys5kJmk11MZ5FmNEKUhESXylY1RVf3kaAVaYavlCigG0h
 /e4bfPW2Pm9t4X3pwly2vPY7U+8Oiw6J9diITObaQw659EIy8dFy43PyRYWFbwnyf4iEocu
 0MI0m21CHD88PGORAirlw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:5op4WafLHZU=;eH58ZpmUhcb1iNkBFMw9pmDKBQi
 qteEas3R8vWZ8OGNrnKxjjqZ7+5gj/7TkBZcn779Qpb4HFQyVVMNBDJ1MqIAIhD9qsRP6g/Y+
 SaLNQxdZoUbq3iOyPCTUqJFC30X8gZHVqa2Kb3kJAynVqbmhBDYLRVeAaN3hhfB1MZD0DmHFG
 r4gLN1ZuvuhtPLNjZQ+r/g6KefV997yLUMFxIUKrX4TzB/D3wKd32MGtEw6IoYutckj/ABSMR
 g4spcXs4APIw9LhoNVYry6zVQweKvE1YGQi3Q86eQgNfIsdaRkutEYB5lPFsEl3y/CpL34glJ
 m9Y2UE5JeO1/IrzBFpdR7MMHAfO2ouA726Ier97UfNosBQQNpIxO/5QI0STnzFFuAu7eGPztj
 /pLlGBbDW7gtW1FPyMp2mO9uwAggv3jLFfLhnXS51y5dTXdo+gqh9tJx08EVT80AYY7C3wQ0h
 AnAg1ojy3SerVXAzAOi9y3oiNEF0206lAfBi+3U0U6ZfZiDC5cC2t5pD+/q7BVQqP9IRL9iB8
 Gv0mB70kFJyDrIqGognasT85vCvqxF1neJRFwTKx2FKc/dIwGmLolNoL5Gi4/LvWxiSM10uqt
 lUF21B304B4cPOMg7FqdMBI+Xpo9KK8ayrx3cN7KCsnnEXi6XARvvgxBYMLpeE/lsbXqqgIxE
 ViZqhgPsZWAZpv+mJWr2gC61mQUymB1r4vTH1P0zVYocQbyWSVU/jtcVQbDiCcF8E+HlSzYP5
 VXdKkJRsY3b3+kZ22e38h4eDpjHxZyLAh071eT8VF5xiDsvUUVi8qddoaP2j1nprq29dPs60G
 jvVTvHWiYLt9G+3AQgKNWoYg==

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 12 Oct 2024 15:48:05 +0200

Some development ideas were taken into account according to evolving discu=
ssions.

Markus Elfring (3):
  crypto: lib/mpi - Extend support for scope-based resource management
  lib/digsig: Use scope-based resource management for two MPI variables
    in digsig_verify_rsa()
  lib/digsig: Use scope-based resource management for two variables
    in digsig_verify_rsa()

 include/linux/mpi.h |   4 ++
 lib/digsig.c        | 107 +++++++++++++++++++++++---------------------
 2 files changed, 59 insertions(+), 52 deletions(-)


V3:
* Applications were added as requested (by Herbert Xu) for the proposed
  programming interface extension.

* Further adjustments were provided for the demonstration of an evolving
  programming interface.


V2:
The kernel build service pointed out that the proposed identifier =E2=80=
=9CT_=E2=80=9D
was not recognised by the compiler.
Thus reserved identifiers need still be applied also at such a place inste=
ad
so far.
I became curious under which circumstances corresponding development conce=
rns
will be reconsidered any more.

=2D-
2.46.1

