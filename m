Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA49B31B830;
	Thu, 30 Apr 2026 22:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777588277; cv=none; b=r3iZO3ew1rTnw7ULsuxWIbtlYR0CZcD0Zco9nQUI/mtyUo44RWMZJO1jd/RoEPWccnB1EJQVZM1TxkmqHNwZDHu6A4o6ewCrhZ9KhUF60kKDbRAWzk4o28DIhl/x6Y7wcgthZF2qvoBOsSWVjOrAZqHIlUSW6a8Oh0ZobxwbOMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777588277; c=relaxed/simple;
	bh=YrVB3lWnJONvO/I89ghk2/VRWedTry/n7muFpHf4NmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=DLu+vLFjnOL/bj970ZkTNk0b02P2J4zPGYZsRFId5+cDTbwoemZbstDSHpoPoXXokVL28AzuJa8rW8m69w7oZBJgm+kOK0j8r4mgkfqyGI+QysAPh62Tll2kz5qVfex9pfQ7u3nrdN+7UWn/QX9WJ1SW7zp3M7zfM3MW7LKA/oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EPSlBzbv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EPSlBzbv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59FA1C2BCB3;
	Thu, 30 Apr 2026 22:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777588277;
	bh=YrVB3lWnJONvO/I89ghk2/VRWedTry/n7muFpHf4NmQ=;
	h=Date:From:To:Cc:Subject:From;
	b=EPSlBzbv1RbHwBXJV7uetz+yDKu8actBKic74nsEIkAE7z/UPtLT3LRqvT+FqzBg9
	 wwVS4GjRLW80TdRRNWpSFAfEckYmJ0iZfaQl7bk2zDsUpylA7I6tIuSHDjzQVrkq6o
	 ucc92kWL+jZhTAVHKyZO/eC79hiVmudEBs7YgEOZyaf7Cwuo7EOp3ATVK5BeqxZONX
	 bpIyzSNGVQHG+mGJQuwX73YY8OiC4i4AFnKEhd8/wR+YmfSc1vlner7A3tXYOcnWYo
	 OZy1++aH84QH7vpAdzTIMEY9WUN0wexQibxn4fjOLNPb4vOE1sR6cbvaFcu7AmvjSR
	 E8E7qUTL6wIDA==
Date: Thu, 30 Apr 2026 15:29:59 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Subject: A couple more AF_ALG fixes to cherry-pick
Message-ID: <20260430222959.GB2275@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Please cherry-pick 5aa58c3a572b3e3 ("crypto: algif_aead - snapshot IV
for async AEAD requests") to 6.18.  The earlier branches have this now,
but it's missing on 6.18.

Please cherry-pick 915b692e6cb723a ("crypto: pcrypt - Fix handling of
MAY_BACKLOG requests") to all LTS kernels.

Note: these bugs seem to be separate from the "copy.fail" bug.

- Eric
