Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF8514EC4C;
	Fri, 30 Aug 2024 09:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725010141; cv=none; b=b0STPL9TZLmC5KAki7xA4J2B03QBJUshLz6tAvxEfaqTeVJlycXBdi+k8bkCu4iA+gFuKJT2B+wLhi1nGIZ59tfC9CK2txCNABFCHqsyBYhbMknIxq8lQphfDACaHlgcpe3VpT1YcPnhqM5DkaWXl0GC5L1ik1VW3f9kbaDPvSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725010141; c=relaxed/simple;
	bh=xys3h/dzYDCv6BjKJpYDaHjuM+mOWpOAzAqWVSdtF18=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z7ZjKiPwHBvBmlw4mzIZAZ5+oFHGZsVRwV2iVuu6C+M4Ta04XvjCExZapwy+EDFZt9J9l5XnAkYeELF+xksYYIlLTtCi9oU8LVMYldmj7Mpno0jv/Zp7fRTGczsboGcL491lslVvC4ZIcNnjbymWFYZEmRkz2P31ot3JzNO83Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sjxnP-008TQU-1V;
	Fri, 30 Aug 2024 17:28:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Aug 2024 17:28:40 +0800
Date: Fri, 30 Aug 2024 17:28:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: syzbot <syzbot+02341e0daa42a15ce130@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [crypto?] KMSAN: uninit-value in lzo1x_1_do_compress (3)
Message-ID: <ZtGQyPAhQNDpSQc3@gondor.apana.org.au>
References: <000000000000320db40620d976af@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000320db40620d976af@google.com>

On Thu, Aug 29, 2024 at 02:50:23PM -0700, syzbot wrote:
> 
> syzbot found the following issue on:
> 
> HEAD commit:    5be63fc19fca Linux 6.11-rc5
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=17d06825980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=522060455c43d52e
> dashboard link: https://syzkaller.appspot.com/bug?extid=02341e0daa42a15ce130
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

#syz set subsystems: mm
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
