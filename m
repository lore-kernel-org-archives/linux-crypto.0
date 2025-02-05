Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58162135A5;
	Wed,  5 Feb 2025 03:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738727755; cv=none; b=t0zSM3Qewl7wD0ezt9gifwxfVRaQdpPvFHVcu5LnmtcTeDgOPNj3Ld6LvDgqHIFYaf6Kdhv3cs+wXaf9nmzwealmHN9GAnudQ6nHxzSj4U4Avy/mXcJZOQt4z6iLf/W3oK2gsa4zhAyzFeSMtzVnpLXZi73d2+rihVTMce589oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738727755; c=relaxed/simple;
	bh=Hxh2SRAP0zMObcV5VTYIvzA4/xncAqz0iygjTf1XkYA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ustbv+3m7VV9Q7MKwJhKmZUrYiD681wOAmrRxTmaEKzDERsJc59+bqNNWTJ42bu1NTNCbXemU9u+krLU/c0YO4uMUNfWtoYAAVvUWY53BQv8gy+UtnFlOOs71SLeuq1ipmRVkTJmmpiZ0wNCD0+OC+DJjpTBJe2Brw4y4Hr3cSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TP5yFMp6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TP5yFMp6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C55CC4CED1;
	Wed,  5 Feb 2025 03:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738727755;
	bh=Hxh2SRAP0zMObcV5VTYIvzA4/xncAqz0iygjTf1XkYA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TP5yFMp6O2wrSwZ2j32dpiGXn/Lr+uagV/aaDIpDZY/CX/e2yOL1s/u8HjYbRjcA+
	 Sr0Tl0AYPHNWqjFNFTVN2xoIdz8H0hzt7bFrYnA1LMldIbKFDNkGWEIlnMuFEyFSsZ
	 ET+4yhWsYFay6VAKqVAfTHWYK3zobfD0X+nRapzmV22z2ZKsFGM630MK0g8djgjRcs
	 LH1BowwB/udDXTXfQwDlphol02qPIXOgmK2SxNUiAB+kvzH8reVe8P2UGTMK1xuA7Z
	 jwKIP+F0JINJSMB2gDSUC4eekqloICxvmHSxXn56vdaMuUcjj5syRDJKbK8eoATx2p
	 ov06eQZ18VcDg==
Date: Tue, 4 Feb 2025 19:55:53 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] crypto: x86 - AES-CTR and AES-XCTR rewrite
Message-ID: <20250205035553.GA117323@sol.localdomain>
References: <20250205035026.116976-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250205035026.116976-1-ebiggers@kernel.org>

On Tue, Feb 04, 2025 at 07:50:24PM -0800, Eric Biggers wrote:
> [PATCH 0/2] crypto: x86 - AES-CTR and AES-XCTR rewrite

To clarify, this is meant to be v2.  I forgot to put it in the subject lines.

- Eric
