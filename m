Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D296F085;
	Wed,  3 Apr 2024 09:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712137146; cv=none; b=up3vsvRAeyYdGuJqvnBnpuEZg9tNr7lfea0PKq6x0Fgq4ho3FoBP6WhDTdbLrSqNDNXlxHyptLBOHvIDbydoQtSaHOMdX1ejW/Vk5OJ38u25+NNWjENy2qfPgG8eUFy3A8iWdv1srCjHMxeqiH86peHrz1FPAkDUOtoasgU+G7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712137146; c=relaxed/simple;
	bh=5BFjPhPhlRf8dXOKuyhkUdZycqrZaTsL4fDumTWDJPc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lD8CgPAC/p7Er6EO54E4c1k47pQNO026NQMCISRNEwL/9r54sEVfnjKag1wuGCkHTWDz1i+Yf+MAUULkQrxhSeZ54zmjsHMJwEGToYxh93lFLJvVwLVOfyeliqsBE/tphgQ/tRsyK/n4fqQAqd7ZE5BN12qq0eseSK/lSdq2y1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rrx56-00EXjH-6r; Wed, 03 Apr 2024 17:38:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 03 Apr 2024 17:39:13 +0800
Date: Wed, 3 Apr 2024 17:39:13 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: syzbot <syzbot+549710bad9c798e25b15@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [crypto?] KMSAN: uninit-value in __crc32c_le_base (4)
Message-ID: <Zg0jwVWTdaGxZwva@gondor.apana.org.au>
References: <000000000000736bd406151001d7@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000736bd406151001d7@google.com>

#syz set subsystems: btrfs
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
