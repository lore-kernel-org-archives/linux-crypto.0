Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B232222AA;
	Tue, 17 Mar 2026 16:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765097; cv=none; b=HHQ/dhUadO2EAFZa98JkQ4SQa3zogTeLvC2NoQS31RALKbq+N+EMI0fQ/Mth+59wMzJ7uiMSjoJ576EQV7rDhs7Tllc+NWicj5iJehEu8IxU6ekx3+NZrDyAWKOEhPMahqrpN9IPETOZEeTGabT6zDWJ/W8BehblYolYkp1YdHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765097; c=relaxed/simple;
	bh=8/FJNnkPO/0g2ymP6/7fbTeBmVZw+yAtGLxHmbLn+io=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bTRzsgTgmf00c0wr8r9q7Qetk+CYuYIVeQ2drWbbszyDR1u5KULfRLNXSOfQH17AFtIPuuQ1nmu1y9qx5xTrIVLnUPHYBI/qR7L01dZSOa7xqF4kcCOhh+1Nvt7BcwDeoCNlaUWEpOoeZlhzgzrpNH9/GkXrmREpyqkOe7aF0V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hkpGq4f+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hkpGq4f+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0BB7C4CEF7;
	Tue, 17 Mar 2026 16:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773765096;
	bh=8/FJNnkPO/0g2ymP6/7fbTeBmVZw+yAtGLxHmbLn+io=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hkpGq4f+UeN57kUA3foH32ltuqqh+l1uEq1RsrJJLtApBgoioFe4pw5gvUcnaheiI
	 t39dP9J0UaOcdrAMnEo9qqQBI4oPjtRoEzKPVKIa8WFPOKAB8mgjbdkRRrQ14W2usr
	 UEvuP4mxw4nfoP/EbMtwIHOCoSu1xUOXNB3JYwRc3JIReo9KmOHuHoj3W1+46EoraB
	 Ze+I5gODti361OEhay3TKdULx2j9BZOk+kHRWQRRHxKH0MMZo3FSTLqg7cGmXdp/lR
	 T3ydZpw1GW0JvFx/yfRXxzc84uk28nvt7eoioY9ROQHey778mgZsDYGng5zOmMUC4T
	 pwZCVo0f6T+6g==
Date: Tue, 17 Mar 2026 09:30:37 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] crypto: crc32c - Remove another outdated comment
Message-ID: <20260317163037.GD2931@sol>
References: <20260316205659.17936-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316205659.17936-1-ebiggers@kernel.org>

On Mon, Mar 16, 2026 at 01:56:59PM -0700, Eric Biggers wrote:
> This code just calls crc32c(), which has a number of different
> implementations, not just the byte-at-a-time table-based one.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This patch is targeting crc-next

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next

- Eric
