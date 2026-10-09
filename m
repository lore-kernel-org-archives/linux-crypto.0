Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE36A32E68D;
	Fri,  9 Oct 2026 07:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791529733; cv=none; b=lT14+VZYpO9m3f4x93Cp087by2NBmz/p3Q1MDCgr9rNp64FacxZaaJ6rs4oFfdYxVIIXnKonHV06yLw0hh75K/NoNL9Ph3s7x5/40p0u6I26NXubxSJkpMn4rOPI9IdbbUArVJhuxN2chBL54lPVE95wbDBWOQUuo77kfX+INd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791529733; c=relaxed/simple;
	bh=8NxBLb8ZNmBXpmw3rwNeLFbP1yNxwK8PHctFf2OXNEU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QT+BUUy2KCHdCZAoUc/sX8uQbkiR1LwDFMamszeskEhFTAMnv/0R3Sy6SyTPG1Taz0ted264UeOsdtdkt0f2yZbadvMqSxstUFKL/uEVh9JhPRW67vEXaxJauY2xZjlfxXU1AosedI7uT9SXI/ve2Q1gpTCB/TdOxsLjka6npZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=UatnvD/o; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="UatnvD/o"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=8NxBLb8ZNmBXpmw3rwNeLFbP1yNxwK8PHctFf2OXNEU=;
	t=1791529730; x=1792739330; b=UatnvD/oj4qeQezeh/XjLdGmZKbnfaOmxMAaR5cX99L9OWb
	BAOPW2R0b/2J+LkxaGnn4kGuN4NdMZQcpFdzM4rot3aOicQ1LyxINqogXZlJMnz+3FXVvb7sn/j5C
	nFyvhWVUNCTabNN+pcaQAJvXu14kTM1NO9426GsFedN4OEYjVXV/InHjKih6mlxqtjwPJ2VyREZTD
	XZQQVUgBzvgvymn9RCnQ00EX+WdhPOwblTejHZgh3fpvYlcphd1473WAYB/N37CNXNKnPuTEDLwXz
	xQ1myt6zWmUxWRQ9uU4F80D1hjczeJgByGDh6mh9Bp9JYF0nW/0cpYhrrGY54R2A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xF4if-0000000ASam-3nJ7;
	Fri, 09 Oct 2026 09:08:42 +0200
Message-ID: <8b9ee18061d7519ca41034c1b25317e43b35d746.camel@sipsolutions.net>
Subject: Re: [PATCH v2 0/5] wifi: add opt-in FIPS exception for iwlwifi
From: Johannes Berg <johannes@sipsolutions.net>
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Cc: davem@davemloft.net, emmanuel.grumbach@intel.com, 
	herbert@gondor.apana.org.au, ilan.peer@intel.com,
 linux-crypto@vger.kernel.org, 	linux-kernel@vger.kernel.org,
 linux-wireless@vger.kernel.org, 	miriam.rachel.korenblit@intel.com
Date: Fri, 09 Oct 2026 09:08:40 +0200
In-Reply-To: <20261009064326.43891-1-jtornosm@redhat.com>
References: 
	<289161e6ddaf18fa63a55623c75d700850fd57b6.camel@sipsolutions.net>
	 <20261009064326.43891-1-jtornosm@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

Hi,

> Is there a way to allow TX aggregation from mac80211
> in this scenario, similar to how the RX path can be
> managed from the host? Or any other mechanism to let
> TLC know that a BA session has been established for a
> TID so it can aggregate? I could not find a TX
> equivalent of STA_MODIFY_ADD_BA_TID in the firmware
> API, but maybe there is another way I am missing.

No. We did this in old devices, but there are relations between the SN
and the queue index and other things, so there's no such API now.

johannes
