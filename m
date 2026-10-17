Received: from 1.mo575.mail-out.ovh.net (1.mo575.mail-out.ovh.net [46.105.41.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D781A6820
	for <linux-crypto@vger.kernel.org>; Sat, 17 Oct 2026 10:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.105.41.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792233573; cv=none; b=sm7nOg0FJW4htDqd/QKDNWivEDPjEOu4O2opx3bs0Oh6VvzE6N96XVCXkNtvTiQEYhsKeQaqkylGZTOLS4eIofstcU1AaalEwhMQChsj3ARO+5stwAAupPT0CkrR0/7uL8HdvEeXMUzDVOQQ30abZz6bOe8upFQr5hKREKr2Rac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792233573; c=relaxed/simple;
	bh=0OPx9zS/HbKkbSyq4RVUIFb0dtxQSmz1XqcSTLn4Wy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X8dxR4evMLv1YI+9Skoyn1M7wdkf03ll/IFWod9c/29J47BXyjUUa/FbLKxFz+f7F/965/+BU4M5vAW3cDioKdJY+AmIl0kYLlMuIutNBghB9L0J0CCpBrPDazejKfNO3xyfWsXZvvaHvxuPj0xB/PhOmm0bn+ZprBFupwON+/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cynove.com; spf=pass smtp.mailfrom=cynove.com; dkim=pass (2048-bit key) header.d=cynove.com header.i=@cynove.com header.b=YkiPdi+e; arc=none smtp.client-ip=46.105.41.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cynove.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cynove.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cynove.com header.i=@cynove.com header.b="YkiPdi+e"
Received: from director3.ghost.mail-out.ovh.net (unknown [10.110.37.251])
	by mo575.mail-out.ovh.net (Postfix) with ESMTP id 4j6JG52JQ1z5vd3
	for <linux-crypto@vger.kernel.org>; Sat, 17 Oct 2026 10:39:25 +0000 (UTC)
Received: from ghost-submission-7ccd8bbbb6-c5nc5 (unknown [10.110.118.184])
	by director3.ghost.mail-out.ovh.net (Postfix) with ESMTPS id 84F15C03E4;
	Sat, 17 Oct 2026 10:39:24 +0000 (UTC)
Received: from cynove.com ([37.59.142.106])
	by ghost-submission-7ccd8bbbb6-c5nc5 with ESMTPSA
	id 6TukOltQ02q3BAQAR877oQ
	(envelope-from <stephane.debusne@cynove.com>); Sat, 17 Oct 2026 10:39:24 +0000
Authentication-Results:garm.ovh; auth=pass (GARM-106R006ff4de083-8d4f-47ea-98b0-cc69cabf982b,
                    E277A82C44659F51833474C02B8FDD9281845D64) smtp.auth=Stephane.Debusne@cynove.com
X-OVh-ClientIp:176.150.47.247
From: Stephane Debusne <stephane.debusne@cynove.com>
To: herbert@gondor.apana.org.au
Cc: lukas@wunner.de,
	davem@davemloft.net,
	horia.geanta@nxp.com,
	pankaj.gupta@nxp.com,
	sahil.malhotra@nxp.com,
	changwei.zou@canonical.com,
	jeffbarnes@linux.microsoft.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] crypto: fix RSA results corrupted by non-coherent DMA
Date: Sat, 17 Oct 2026 12:39:18 +0200
Message-ID: <20261017103918.2797952-1-stephane.debusne@cynove.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261016090333.2247764-1-stephane.debusne@cynove.com>
References: <20261016090333.2247764-1-stephane.debusne@cynove.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
x-ovh-tracer-id: 5790784696703900476
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: dmFkZTE/KwknBQhqI+u/OBT3gRGYsILezjKJ5C03ZK+608YlbSLyHJ4FfE40bU/rGtsjUddEaH1JCvbfslRrBrqD9cVJMqKM9itFPT2ZW+d0WQxWdCq81h/Wv8+Lb0LcjLuIKg2+pGH7xWYwbR1TDWgDA8K+yJzjbNWvphiQrrGwg/1Lf779dtmtPeGzSoM4FBx54dYEXZ8/i734XI++JaQfRh60n2l0nvMjt5K4tPDpmsjhFnDE5BFPbt6Kqwxxpg73irjk6Wyaf4HhYWHPJtrd3h8+YXCV2FU5hbw367uvKu62bUQ4YGilhzx/x032Bqn9xM/Fo0EjNUnLrEN9cakdHip1oEy8x5Vz+PQJ30hefiowjUHEXGHIYcFAYvPaApP2gRCWakHFLQxkAI31h/4DQeOfjrNDy+ndLEZbSwIhnR9JmQ71YwYUpudwGEm35SjESrykkhi9xOsFGO2i2epHsyi0Scegnzxj3VGuYSoKGJWw/KJJ+3ZvYGRMWjkbmMIcFlE5l6E+nfQ1Jt3pdXlwqxjPFVXJKkpmMwEKSFojmWtvCYex8613ll30pt3fpauNWitce7vMTdpfu09E9LrpKUvDRaFpcOtAwB8T9CkoboOx8u81oRWu8DjGjklG5bhrmpqgwEI6cljrJDN25L2f3Qsm4xYSwqc9iRnqxY6cEO1W2g
DKIM-Signature: a=rsa-sha256; bh=0OPx9zS/HbKkbSyq4RVUIFb0dtxQSmz1XqcSTLn4Wy4=;
 c=relaxed/relaxed; d=cynove.com; h=From; s=ovhmo4616632-selector1;
 t=1792233565; v=1;
 b=YkiPdi+eMcOdZj0Ytwow9a1IgjiY1H5eIIMI1LTrtUfTXbR0RHQYktsezscDnv8XHJSF9nFo
 GabhvK4skgIRtMPSQgiOXf4ve5cT+q7fMX9bUIhcdzTHOq7CYik+I1K9Yqjulf+hBvoxcoL53yW
 mSTPkVZNdL1vmkOui4D1rjNkjFjn006DU3yYtnY3DN1nztXN2q8Uj4yiPXvTyCaHBrrYEAUzbXK
 jUdbtpSSEjAG5MAH1LkwKY0o9CQdZ8quSvLs/wS602ZOEUL3tV11TlyCfF21GSveOPkOg6WIlUP
 rQlpGoZc7b94fa7lYQc7CDaGzY/R3gl0Y9YLdWTDEU9rQ==

Hi Herbert,

Changwei pointed me to your answer on a similar caller-side fix [1]:
alignment is the driver's responsibility. Please drop this series.
Changwei's driver-side fix [2] corrects the same corruption, and I have
tested it on the i.MX8M Mini.

[1] https://lore.kernel.org/all/am2UMhd5CAhDiKBF@gondor.apana.org.au/
[2] https://lore.kernel.org/linux-crypto/20261004210200.290119-3-changwei.zou@canonical.com/

Thanks,
Stephane
