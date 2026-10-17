Received: from 13.mo583.mail-out.ovh.net (13.mo583.mail-out.ovh.net [87.98.182.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839824CF477
	for <linux-crypto@vger.kernel.org>; Sat, 17 Oct 2026 15:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=87.98.182.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792252511; cv=none; b=odjlCBu0hl95YnIGzqbuArkUEfPxDBSASipSFCb/UGmx8D4sdBl1WbyVfi89FhKNrSQCoJlRHoSdTOXSD8d4SzNvqTnbd0WDlVLE2ZMEfn6Nr0CUh/x6+C8EEdSCDyrtZXoZm231y77jYkJjAZprbbM5bgfMBToCR1MZ5P/bdK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792252511; c=relaxed/simple;
	bh=uCQaig9rEgF3+aw2tds27Jcd3vh04Y8p7BFJnWSwwpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UNaCYfn3AMckKSNHZx/oKSqWkH1qCckDiKZCfaN0yxzhoENm7I5fkTsfrzzRxbeUKkfWzsraxrrmyUG1UfddVaKfxgDDzbN413gbjGJKrOoTIbB8+7G24KQtXO8XB3wRAMhv3yJgZAt1/tziqFqkwWTCU9APAqtMUJ4XJ01xiA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cynove.com; spf=pass smtp.mailfrom=cynove.com; dkim=pass (2048-bit key) header.d=cynove.com header.i=@cynove.com header.b=XUZFJnG1; arc=none smtp.client-ip=87.98.182.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cynove.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cynove.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cynove.com header.i=@cynove.com header.b="XUZFJnG1"
Received: from director11.ghost.mail-out.ovh.net (unknown [10.110.43.44])
	by mo583.mail-out.ovh.net (Postfix) with ESMTP id 4j6Qw33Vztz5xy2
	for <linux-crypto@vger.kernel.org>; Sat, 17 Oct 2026 15:39:15 +0000 (UTC)
Received: from ghost-submission-7ccd8bbbb6-lmllg (unknown [10.110.54.2])
	by director11.ghost.mail-out.ovh.net (Postfix) with ESMTPS id 066D5C2921;
	Sat, 17 Oct 2026 15:39:13 +0000 (UTC)
Received: from cynove.com ([37.59.142.106])
	by ghost-submission-7ccd8bbbb6-lmllg with ESMTPSA
	id cwkeN6GW02rJaAQA3SBaag
	(envelope-from <stephane.debusne@cynove.com>); Sat, 17 Oct 2026 15:39:13 +0000
Authentication-Results:garm.ovh; auth=pass (GARM-106R00606d3a3a0-4c64-47ff-91af-fdab2a6dd61d,
                    E277A82C44659F51833474C02B8FDD9281845D64) smtp.auth=Stephane.Debusne@cynove.com
X-OVh-ClientIp:176.150.47.247
From: Stephane Debusne <stephane.debusne@cynove.com>
To: changwei.zou@canonical.com
Cc: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	jeffbarnes@linux.microsoft.com,
	lukas@wunner.de,
	horia.geanta@nxp.com,
	pankaj.gupta@nxp.com,
	iuliana.prodan@nxp.com,
	sahil.malhotra@nxp.com,
	sahil.malhotra@oss.nxp.com,
	martin.kepplinger-novakovic@ginzinger.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] crypto: caam - Use bounce buffer for unaligned RSA destination buffers
Date: Sat, 17 Oct 2026 17:39:08 +0200
Message-ID: <20261017153908.2813630-1-stephane.debusne@cynove.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261017102047.333792-1-changwei.zou@canonical.com>
References: <20261017102047.333792-1-changwei.zou@canonical.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
x-ovh-tracer-id: 10854519530342570812
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: dmFkZTFItG+dckT/CYq7g4nK61jBfak3V94fQHIvYK7SXdxWl7LpwJIUCm5QByplztHFQNN/lG1XP4gSF0UmDfDjreJDWVsXPcz+oE+3K6XkuCtP1ZNd2QH3dAqaKohcBtkU7KVYj92bY/7wuf68ev2MoAsp6qszwIKgHCJXHAWAMwo/9DttfYFwmB5v6etLK42WAatG+S99/R+PtEOBO8Wq7FaXcvO4P6UBSsVzixbYtpoMvwuLv6GnxU10qry4rLndw70Aq2h6SCE4nC/K9MOOImziXmzaIzrdE8Siinyi+rLHKPbgKlbbcYbiJ5Rs8gYaJFnjJ+88n+oD0Ce+2NiE75RRDPQkiCq1jsfSPBNgLcgg0qTe5BiWnDB++G9z9MZQ8rsv6xI65CsQe5WuALRyaKXD20yheMj6otO9nrBil+q/4P+jbfNde4gH8pvhGql5Qt66mL7NRTFUdDMVUtaYXpyO8r4Pe4w65r50CirFnHyOT2O3sFAKoMGgRgjbKGeKLxqFPoEj6GjziXnuXKuMsaF+Mi9HT72/URKEn9i0NV3E7b8wmjVR0eM72rnM7eaqX3Tyh/7qvQZu9cTOmCUTmBdUAWUbobS0SD5U81+au0HJ489OtD7lN/WFFvrLg3QcAoW4N6ICiQGlt4ee09ZSRgVZbHgGmgDDF4SR7GjFh0FGHw
DKIM-Signature: a=rsa-sha256; bh=uCQaig9rEgF3+aw2tds27Jcd3vh04Y8p7BFJnWSwwpQ=;
 c=relaxed/relaxed; d=cynove.com; h=From; s=ovhmo4616632-selector1;
 t=1792251555; v=1;
 b=XUZFJnG18D9d+4WJNzrc1qn2b9kDLvEeP3UsI9saQPpSqXrGKh2HHaTOQrdc82ukEo9Xe+0D
 EOWhFaQM1/AMv2bkpNAlHorx8UfIBN3SdeNUuzwoEb9KcDMnSuPiQMdwtPq//s5fpD4NePIh9IJ
 poW8jjASlKPcRXzvbkfknbyZHAcPoQ5urGALOybEPQoLx5tRotMQld7UdgndjMZn+mAen/GLgVL
 ElSZbQ7YVPqabFonbck5H31FRs7TpAlIEfFOyEqP9UKz5H4CkigFgMHouQHWyxXctTL4Ze9cOdA
 cDZyQhH+CLnJfg8HOG6LUTkMAhRDJP9whNaP9IjNP8l/A==

Hi Changwei,

On Sat, Oct 17, 2026 at 09:20:47PM +1100, Changwei Zou wrote:
> Therefore, I later switched to a driver-side solution.

Thanks for the explanation and the links. I have asked Herbert to drop
my series.

Stephane
