Received: from 3.mo576.mail-out.ovh.net (3.mo576.mail-out.ovh.net [188.165.52.203])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D580D3D47C3
	for <linux-crypto@vger.kernel.org>; Sat, 17 Oct 2026 08:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.165.52.203
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792225416; cv=none; b=KCttd9ZX7twHX7X6AwHy+lAI3TaW6Degj3HSbmjyrLsupyBSp/zE3aVAwDTEXYkJpPS+VQ14bmJ51oK0iuktFem3mT4k1cotiA+qTLVJPl49KvKEGNc9Be9HYuVwpJarViEOnB8VB2EKZTCruiPcc7OYtZgMcFvXDetVSlGH2KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792225416; c=relaxed/simple;
	bh=/IHyucPgWJL238L3Cj1FRQRAX+5h0KJLX3Hygpqkc40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GX2Kt+d7qgpGD9Aj/tkJHXSpYT382vvMKH8272rAUnWZjYORJiCis9LK6KAz/mdp7y0X7OUE1/QcErFa8ZOMsxikTGv0d8qJiphI0BCI4xs6VQwhV8RHo95zvAxfz0WvmVJ3uR6nk6D78MiV5P6+lv4mv6EnsI1Fce1fd4Ss4Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cynove.com; spf=pass smtp.mailfrom=cynove.com; dkim=pass (2048-bit key) header.d=cynove.com header.i=@cynove.com header.b=IXdsETz9; arc=none smtp.client-ip=188.165.52.203
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cynove.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cynove.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cynove.com header.i=@cynove.com header.b="IXdsETz9"
Received: from director4.ghost.mail-out.ovh.net (unknown [10.109.231.137])
	by mo576.mail-out.ovh.net (Postfix) with ESMTP id 4j6FFB3p9Wz5wyp
	for <linux-crypto@vger.kernel.org>; Sat, 17 Oct 2026 08:23:26 +0000 (UTC)
Received: from ghost-submission-7ccd8bbbb6-g6jb4 (unknown [10.108.54.81])
	by director4.ghost.mail-out.ovh.net (Postfix) with ESMTPS id C07F7C21CB;
	Sat, 17 Oct 2026 08:23:24 +0000 (UTC)
Received: from cynove.com ([37.59.142.113])
	by ghost-submission-7ccd8bbbb6-g6jb4 with ESMTPSA
	id eIt3Inww02pz2QMAZOlizA
	(envelope-from <stephane.debusne@cynove.com>); Sat, 17 Oct 2026 08:23:24 +0000
Authentication-Results:garm.ovh; auth=pass (GARM-113S00773237b66-6d21-42ca-ae0b-f7fe8c6ad06d,
                    E277A82C44659F51833474C02B8FDD9281845D64) smtp.auth=Stephane.Debusne@cynove.com
X-OVh-ClientIp:176.150.47.247
From: Stephane Debusne <stephane.debusne@cynove.com>
To: jeffbarnes@linux.microsoft.com
Cc: herbert@gondor.apana.org.au,
	lukas@wunner.de,
	changwei.zou@canonical.com,
	davem@davemloft.net,
	horia.geanta@nxp.com,
	pankaj.gupta@nxp.com,
	sahil.malhotra@nxp.com,
	sahil.malhotra@oss.nxp.com,
	martin.kepplinger-novakovic@ginzinger.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] crypto: fix RSA results corrupted by non-coherent DMA
Date: Sat, 17 Oct 2026 10:23:16 +0200
Message-ID: <20261017082317.2775260-1-stephane.debusne@cynove.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261016221414.4139377-1-jeffbarnes@linux.microsoft.com>
References: <20261016221414.4139377-1-jeffbarnes@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
x-ovh-tracer-id: 3494230363695602492
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: dmFkZTFC0NVPapUsqSmwlY+ug/ypEzIFW36uKGDnmDjmnkLgzhgj97q+qmgd7PEmAPr7td23YlDUwMpsY9yY1LCGDA/P8DKwYAM+uhoxtwJOZKyUUwcRTf8//ksd0oT6ohqxRn5wvhUYFHjN0nGHo6RpuLXsTt0YSBts/2ElvGIO+Kdg21+zQicV67+wTC/a2a8DfO8uSG2Cg4HUKcQAwUMjWjw4tpOgea3XsGWQNhYDN/QLp2C9OchayWuurujEHr2q25Qn8pabJGHIkU+nF10N7OXaf2+92AqUElN09yD0b2q+BV/+gsb2pGL8or6Rft8bHDSaYbI9WXKp0HncpB0s1DeCtRS+7ggZr1ed6Big6Uf4s6YL9mGgKEoqvWfa1QEcDDhw0NND6ka7E0rk8mmijT8/56gb1ysmdjb5HPi6pqHVoQzUA8AXwGuHb9a4F3vqnWU3zWHYdEg0OHMulB4rQSu+Y2jmo97PhryCfFqOig+5GKy4QFea/OLCtVayHQ27hGYwrltB3DdRN2m1gRIH418f4fUAmjXVH3ynOxdGj3lWnmqs0rjsIvlCYtulT4svg2frN08s7GcsqBf9pHLlxtDU8qQ4jx5WCRVQGA68FN7JxELRBIAfGRfvv8WyNkF/aFfLc152NcqkDwGonTEjqClpT6RHlfl5IrALr7epCWeszA
DKIM-Signature: a=rsa-sha256; bh=/IHyucPgWJL238L3Cj1FRQRAX+5h0KJLX3Hygpqkc40=;
 c=relaxed/relaxed; d=cynove.com; h=From; s=ovhmo4616632-selector1;
 t=1792225406; v=1;
 b=IXdsETz9GpYYT/z3LtBzxqDSUUol/5ro50tOwy0/KnAYutdDZgfaqJ10rFOJJzcZzfZJxdwi
 S89IsPCqWbN9f5mdWgH5cc5yPNKWgLvxUfLMrtrQh7ZMndjSPkAS43XejRu0acBMZIElDv5RgR4
 PVI6zeukmFYKE8VlitbZczjZbgFdl3oStWBYaUqxaRuPGeVvbuLlh+pBX6FwWgjV/VTUns2Jttd
 lWKdT5AJTfSKeZLvqeg4asISuJX4o1yJopg15nW6qVJefBWl9M0EEIOmrOCEQX1kmdbuOFxstd8
 keXLrl4HdeDk4ujea1cqKx8oL+0gPKNNfUS7wb1OswHsw==

Hi Jeff,

On Fri, Oct 16, 2026 at 06:14:14PM -0400, Jeff Barnes wrote:
> Your patches move the synchronous-helper and RSASSA-PKCS1 buffers into
> separate allocations, while intentionally retaining src == dst.

Yes. The in-place request shape predates this series (the sync helper
has used it since it was introduced, rsassa_pkcs1_verify() since
8552cb04e083), and I understand in-place requests to be valid for
akcipher, so I kept the series limited to the placement of the buffer.
I agree that the two issues are independent.

One data point from the i.MX8M Mini (CAAM era 9, non-coherent, no IOMMU
in front of the CAAM): with dma-direct, both mappings of the shared SG
return the same address, so the double mapping has no visible effect
there. In-place requests on a buffer from its own kmalloc() gave no
wrong result out of 200 in my test module, and with this series
applied, rsa-caam passes signature verification. I have not run with
CONFIG_DMA_API_DEBUG, which should report the overlapping mappings even
without an IOMMU; I can do so if that helps.

> Would the preferred direction be:

I will leave the choice to Herbert and the CAAM maintainers. For what
it is worth, a narrowly bounded RFC (your option 1) seems the easiest
to review, and I can test it on the i.MX8M Mini as a regression check
on a non-coherent system without an IOMMU.

Thanks for the pointer to Changwei's series, which I had missed. It
fixes the same corruption from the driver side. I have now tested it
on the i.MX8M Mini: with it alone, the buffers built by the sync helper
and by rsassa_pkcs1_verify(), which are not cacheline-aligned, are
bounced, and rsa-caam gives correct results. I sent my Tested-by on his
thread. The two approaches are complementary: with my series those
buffers are aligned and need no bounce, while the driver change also
covers other callers.

Thanks,
Stephane
