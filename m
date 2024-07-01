Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D02C137E;
	Mon,  1 Jul 2024 14:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719845132; cv=none; b=GcVbReF9q7swVJ+CXOFtlh29TTcpAh9q/+uhFT1DD3zn2y9Tx8WsGaXlA83M4RhC4ZSRdzIrv3yiFq61+nedZLzeI4yQbofb5Ay/jH7wBu9ozvBQH6leAMJBCXeTrmGLFalCSiKwC8mFOWj3kt+Y1T6psQmdCk91qt7dc3+9tQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719845132; c=relaxed/simple;
	bh=nVoWhZ54bVbfutTma+csFUuBOmOpNcmPuKkxTkG+LWU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ljmEK/8ehYA/cEuoTx4UH+NizZN9XYlRP+gzRptl9vbVxhkXKvg9FHi8hBiazdF9ULx8wmmbamYzS1d1hadLJEFk9w1kCITki6iUT5iV+/k1QjwwA3WcNOgOvkCxkDGq7RE8M2rJhgLCX34tL7ut2AP4+2P0sYPKLQxrixBQ5nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e0XF8UQl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e0XF8UQl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A19C116B1;
	Mon,  1 Jul 2024 14:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719845131;
	bh=nVoWhZ54bVbfutTma+csFUuBOmOpNcmPuKkxTkG+LWU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=e0XF8UQlw8JDBtI9/0JHTQGCUtwDaV+CTfSs1JFNJkgINOrxziqEY7v6M9vzSOWdw
	 tBcK7TS4BmHUQjP7u7HGYSWBTlW4g+1q+A1LJ6buAXL9XBjM8hItMPupgKH/1JmL9n
	 GsNVwqy/086U9l7N/b+du3wGSUEvOo+bYudWzu0kBUmST/vrhL4xZ6Pt9p1Lh3iJsE
	 M3fUKo7hhNuWE8IQUE1KTTJGXAV66ga0VeyFAls5Iq8VxsW4ferQqBE9HPBfjWbEw2
	 tHY/Qjvj0ezlIDk2DcQlqNfAg8N0Ou/DgHPx8WlZuliJN5sM1XMuRupNIO7Bv/e/5k
	 pgdUFMSzePL+Q==
Message-ID: <85c8e8095d22db8923c10a180d9e91c61ae64c54.camel@kernel.org>
Subject: Re: Warning at crypto/testmgr.c:5900, while booting to OS
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Venkat Rao Bagalkote <venkat88@linux.vnet.ibm.com>,
 stefanb@linux.ibm.com,  herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 01 Jul 2024 14:45:28 +0000
In-Reply-To: <25d1a371-a4be-41d9-a3ad-f97bd9348dbc@linux.vnet.ibm.com>
References: <25d1a371-a4be-41d9-a3ad-f97bd9348dbc@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 (3.52.2-1.fc40) 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2024-06-12 at 12:16 +0530, Venkat Rao Bagalkote wrote:
> This issue is being caused by the patch: 2fd2a82ccbfc106aec314db6c4bda5e2=
4fd32a22.
>=20
> After reverting the above patch, issue is not seen.

$ git show 2fd2a82ccbfc106aec314db6c4bda5e24fd32a22 # [1]
fatal: bad object 2fd2a82ccbfc106aec314db6c4bda5e24fd32a22

Unless I made a mistake, for me it really looks like that the commit is
non-existent.

> Regards,
> Venkat.

[1]
commit 22a40d14b572deb80c0648557f4bd502d7e83826 (tag: v6.10-rc6, mainline/m=
aster)
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Jun 30 14:40:44 2024 -0700

    Linux 6.10-rc6

BR, Jarkko
