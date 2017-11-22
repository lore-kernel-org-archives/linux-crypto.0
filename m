From: Helmut Jarausch <jarausch@skynet.be>
Subject: loop-AES-v3.7l fails to compile with kernel 4.14.1
Date: Wed, 22 Nov 2017 13:14:36 +0100
Message-ID: <MZOEX4JB.4MTLWCNZ.WVQW6OFO@PQ3FRN6F.EJZVY5VO.F4T5GYSS>
Reply-To: jarausch@skynet.be
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Transfer-Encoding: quoted-printable
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailsec107.isp.belgacom.be ([195.238.20.103]:41998 "EHLO
        mailsec107.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752483AbdKVMOi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Nov 2017 07:14:38 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


/var/tmp/portage/sys-fs/loop-aes-3.7l/work/loop-AES-v3.7l/tmp-d-kbuild/patc=
hed-loop.c:530:7: =20
error: 'struct bio' has no member named 'bi_bdev'; did you mean =20
'bi_iter'?=
