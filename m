Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC54425CC6F;
	Thu,  6 Mar 2025 17:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741281728; cv=none; b=imnVvoBaWLFzaSckOw6h7Mh7NxENngIZYYB8BYOQJePusLMIzI19HsidfwbeuXlRt4D6Ec6vpdUWGemUbrEJKTGLGdw6lACfurA68gMbdPthaTsHOgL8ZXWxYYcCmgOCTDrNKC3MX4HYxqP2pv3ncEque2em5y4J1ya4ltkQzjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741281728; c=relaxed/simple;
	bh=kpPa1Mgo4gmG/WdBTpDpjOa5+d4R0acz2TKv51RuH1w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hLFevcLLQZWNEektTdcmgC3jcsp4dGI1azG3cb94RtOXzEBuqqcbvbtK+UvsnqkDz7A8ypbZInZdjOB0IMUTIUHfQVLu3MRAMu0c723b2zQBOPqMzhXJntnEYo4z57oLO+UVcmY2jTuRFCZMUIq5xY7Yxztxcfr6WpnpCXGXHQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oL9Tl0Ql; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oL9Tl0Ql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B132C4CEE9;
	Thu,  6 Mar 2025 17:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741281728;
	bh=kpPa1Mgo4gmG/WdBTpDpjOa5+d4R0acz2TKv51RuH1w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oL9Tl0QlT7sZA4L0bRZQiMJB9BNgt4FQLyEkNu/StmnyazKU+5HvcLu39Tq81jyZy
	 IJfhrZrz/VVZtGgYCjB1QTvHnSnPNE0awIaqf3LpisXWX22JQE2sTED5xIxeuRHCIr
	 WHsmk5k70SKZji5XoRe6hxeAn+g4N01aHH/h3f8EyTTOL28yyHk+kSk60txX5WcSmG
	 rsBYzxjZ7O39w4ogR6zanbkV7wywPxIAix8DljD2UfauWSqiz4rTyarNrt6CwSlBb4
	 XR+loialGv0X/m0umoLDyBrh8y4bbN3JkATzcAfFB2xm5gZc4m37CV2ysMsJmvGrCh
	 OmUjm1xsquzOg==
Date: Thu, 6 Mar 2025 09:22:06 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] lib/crc7: unexport crc7_be_syndrome_table
Message-ID: <20250306172206.GD1796@sol.localdomain>
References: <20250304224052.157915-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250304224052.157915-1-ebiggers@kernel.org>

On Tue, Mar 04, 2025 at 02:40:52PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Since neither crc7_be_syndrome_table nor crc7_be_byte() are used outside
> lib/crc7.c, fold them into lib/crc7.c.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  include/linux/crc7.h | 7 -------
>  lib/crc7.c           | 6 ++----
>  2 files changed, 2 insertions(+), 11 deletions(-)

Applied to
https://web.git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next

- Eric
