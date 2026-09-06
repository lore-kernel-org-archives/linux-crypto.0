Received: from mail.mainlining.org (mail.mainlining.org [5.75.144.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9FE36F906;
	Sun,  6 Sep 2026 11:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.75.144.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788695710; cv=none; b=GdhTNYwObPgnks6t9upQPs+hGuev74fxQKS5YPYwWLPlYgFChsBU1b1wRF/LWhbpy+nVFGPzyBtrLhOhQTRaNkAXPAJpxn4qefH2u3VnHO6HOW3ajmPGmlr7M4a70dJNjnkwVeXko3gQ5JCQ7ZActzlg2p+UzxapLnWbACkSbik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788695710; c=relaxed/simple;
	bh=DXOXk918CrUxRyLGQC+wWSy1ynECjR58HLc/uA9ZQ6M=;
	h=Date:From:To:CC:Subject:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=c4Huu3nOZ1BuzcBdm49fje4i35aokMwNiIF7eBZU9N2lcZg+JyYUKj6ikzpKcIY6v3iEXCqa8jVbCMWKOoGyw9J82kEDwHr8N4hy94IPK84LGdEUPJvJO3JK2X6tHQ6XTBFY74kERc9MDhCCRn/3nMqMtGS8MYok6vikouwKqoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mainlining.org; spf=pass smtp.mailfrom=mainlining.org; dkim=pass (2048-bit key) header.d=mainlining.org header.i=@mainlining.org header.b=NhD2MJyh; dkim=permerror (0-bit key) header.d=mainlining.org header.i=@mainlining.org header.b=9gehSagI; arc=none smtp.client-ip=5.75.144.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mainlining.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mainlining.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mainlining.org header.i=@mainlining.org header.b="NhD2MJyh";
	dkim=permerror (0-bit key) header.d=mainlining.org header.i=@mainlining.org header.b="9gehSagI"
DKIM-Signature: v=1; a=rsa-sha256; s=202507r; d=mainlining.org; c=relaxed/relaxed;
	h=Message-ID:Subject:To:From:Date; t=1788695702; bh=atp8Nzk+WejNGVW3ipviPf/
	4pyVkDMiYmPEmhaV9hl0=; b=NhD2MJyhdd65kyO7v3QHaqTVX1rer0NoS8AFXjLHDqNJHAPynM
	D2/0iwe/keAsqYb1HmuBhkrPX1WnJGF6reojJZgD48dvRK8RtfFUP9AS9lOS7y3LjcIzv2sDcpX
	RiNpFrPaKYNQ0a4n8JXH0bL93RHtbiPZk2vTn9O+Z2AvXK7XIz6q6O8QjB/IVod/ij27lqCxAQZ
	PvUAUKwtNW4e0PYmwZ6bbk3hckzTqCTTxyQsAfolqQIU0Ae2NKSXUCSJ3tG0kJH9hB/D6kN0JOb
	g0BbdztBVtSGnN+ARsnOcfCh1iol7UM657ltXtWv4w3l6CQ/ZEGH47iCbfH8QxxpCEg==;
DKIM-Signature: v=1; a=ed25519-sha256; s=202507e; d=mainlining.org; c=relaxed/relaxed;
	h=Message-ID:Subject:To:From:Date; t=1788695702; bh=atp8Nzk+WejNGVW3ipviPf/
	4pyVkDMiYmPEmhaV9hl0=; b=9gehSagI1rghRLNtpf3AWlMaOXEINjGnfKYiR1TWO0cPKCihUo
	9G9M6kYX3IWJItaNpW34KlkuCPW3VsKzDDDg==;
Date: Sun, 06 Sep 2026 12:55:01 +0100
From: Bradley Morgan <brads@mainlining.org>
To: hemanth.selam@gmail.com
CC: daniel.m.jordan@oracle.com, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, steffen.klassert@secunet.com,
 akpm@linux-foundation.org
Subject: Re: [PATCH] kernel: fix typo "dependend" in comment
In-Reply-To: <20260904123821.40427-1-hemanth.selam@gmail.com>
Message-ID: <F5808EE0-47EC-4C34-9B19-4C411C2C87A6@mainlining.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

On 4 September 2026 13:38:20 BST, Hemanth Selam <hemanth.selam@gmail.com>
wrote:
>Correct "dependend" to "dependent", reported by scripts/checkpatch.pl
>using
>the misspelling list in scripts/spelling.txt.  Only touches comments, no
>code changes.
>
>Assisted-by: Cursor:claude-opus-5
>Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
>---
> kernel/padata.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/kernel/padata.c b/kernel/padata.c
>index 0d3ea1b68b1f..5a113c667d4c 100644
>--- a/kernel/padata.c
>+++ b/kernel/padata.c
>@@ -534,7 +534,7 @@ static void padata_init_reorder_list(struct parallel_data *pd)
> 	}
> }
> 
>-/* Allocate and initialize the internal cpumask dependend resources. */
>+/* Allocate and initialize the internal cpumask dependent resources. */
> static struct parallel_data *padata_alloc_pd(struct padata_shell *ps,
> 					     int offlining_cpu)
> {
>


Whatever. 

Reviewed-by: Bradley Morgan <brads@mainlining.org>

Not worth merging but whateverr

--- Thanks!
https://lore.kernel.org/all/EE579805-42F2-4C58-B752-F28779EEB717@grrlz.net/
