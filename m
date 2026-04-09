Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6D233CEB0;
	Thu,  9 Apr 2026 07:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=130.133.4.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775719769; cv=none; b=XVVaCTKgAdQrfccrUXvLxJj/4jk3hXib6mNGPD7EdCy0Br8Gy1pjGvSzqKqP7jbXaqXYYWmbIOwz+udyyJyyVFWX9JmojRd3p3wBZmCu0QpZe54ryjrzOAVT4bB27AA5ooMbDsCWol017DOr24ZOk66OPkcy/muhxlC+AwzrXRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775719769; c=relaxed/simple;
	bh=pgP4ITqp7BEv/mm7v7nYM4hud+IOUP4yblJtsP+Ky58=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RUA3WdFhFeJw00xuMy6veYzy8oAd9qXg0QHEYPgqHlvM0u55NRjXNkkP+Gr7wKNUOrfMHvnq5lppfXP2m1jXVX05pnGfANMKvDag1kBXkilgn6OpK7bMD47NaXkcb2/LzZ/ILSryLY6NnS4107R7N39HiPHq+U8n3RAR2r1eZ54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=physik.fu-berlin.de; spf=pass smtp.mailfrom=zedat.fu-berlin.de; dkim=pass (2048-bit key) header.d=fu-berlin.de header.i=@fu-berlin.de header.b=Gk7HBT/v; arc=none smtp.client-ip=130.133.4.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=physik.fu-berlin.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zedat.fu-berlin.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fu-berlin.de header.i=@fu-berlin.de header.b="Gk7HBT/v"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=fu-berlin.de; s=fub01; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:From:
	Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=meTyPeCnlBM5SPOmkLrRKvdYTiXe61j4Zp+GNBYqKO0=; t=1775719766;
	x=1776324566; b=Gk7HBT/vTDHbS1rnTNXkfkknIvvhpuWeyVsG6p6D7hscOadhSRYFHPDO+A4P2
	aNOXD04HMlypE7H8nmIKx72kzrsM4j/IPn0bI5ehI0waVrxZ6GxFrE6wUJBHQUq52ImPWRVdaT+wH
	+gMDIOQwZsohTSD4hU5vkP5WEtaQP5lOc3kqgtpYhifPKbJfLpExZhFHIcQuM+C1/gnwY3DSRX5CQ
	Z3UJz4IdcUzMM+WXzzvsfGeHigEqWzO/RML2y1hOvfUPsB2hyUVC90TdR8moV/ikCrosMusFtX9X1
	+3bI0ZI6PpbZYYZMaLAO4wZQO+JadRxm3wn2A+4vAXvvyGiEfw==;
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.99)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1wAjpL-00000001rsz-2ZJa; Thu, 09 Apr 2026 09:29:23 +0200
Received: from p5dc559e1.dip0.t-ipconnect.de ([93.197.89.225] helo=[192.168.178.61])
          by inpost2.zedat.fu-berlin.de (Exim 4.99)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1wAjpL-00000002efj-1dpX; Thu, 09 Apr 2026 09:29:23 +0200
Message-ID: <d5fb24534a56017e622ef15272eb2f0cfc6d6de6.camel@physik.fu-berlin.de>
Subject: Re: [PATCH 1/3] crypto: s390 - Remove des and des3_ede code
From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To: Holger Dengler <dengler@linux.ibm.com>, Eric Biggers
 <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, 
	sparclinux@vger.kernel.org, x86@kernel.org, Harald Freudenberger
	 <freude@linux.ibm.com>
Date: Thu, 09 Apr 2026 09:29:22 +0200
In-Reply-To: <09684f23-8937-4fed-b88a-361c9ccef04c@linux.ibm.com>
References: <20260326201246.57544-1-ebiggers@kernel.org>
	 <20260326201246.57544-2-ebiggers@kernel.org>
	 <09684f23-8937-4fed-b88a-361c9ccef04c@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-ZEDAT-Hint: PO

On Thu, 2026-04-09 at 09:08 +0200, Holger Dengler wrote:
> On 26/03/2026 21:12, Eric Biggers wrote:
> > Since DES and Triple DES are obsolete, there is very little point in
> > maintining architecture-optimized code for them.  Remove it.
> >=20
> > Signed-off-by: Eric Biggers <ebiggers@kernel.org>
>=20
> Reviewed-by: Holger Dengler <dengler@linux.ibm.com>

Wouldn't it actually make sense to keep the old crypto code so we get
additional coverage for QEMU's emulation of crypto instructions?

Adrian

--=20
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913
