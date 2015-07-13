From: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>
Subject: [PATCH 0/2] Uncomment VSX enable routine for instructions access
Date: Mon, 13 Jul 2015 13:50:14 -0300
Message-ID: <20150713165011.GA3356@bluepex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linuxppc-dev@lists.ozlabs.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	pfsmorigo@linux.vnet.ibm.com, Michael Ellerman <mpe@ellerman.id.au>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:37106 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbbGMQuW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Jul 2015 12:50:22 -0400
Received: from /spool/local
	by e24smtp04.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <leosilva@linux.vnet.ibm.com>;
	Mon, 13 Jul 2015 13:50:18 -0300
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

enable_kernel_vsx() was commented since anything was using
it. It changes with vmx_crypto driver that call VSX instructions
and need kernel_vsx enabled in order to do it properly. Without
a way to enable VSX instruction vmx_crypto fails into an exception.

These patches uncomment enable_kernel_vsx() rountine and put it
available for use. Also adds it in vmx_crypto in order to
enable kernel_vsx before use VSX instructions.

Leonidas S. Barbosa (2):
  Uncomment and make enable_kernel_vsx() routine available
  Adding enable_kernel_vsx() to access VSX instructions

 arch/powerpc/include/asm/switch_to.h | 1 +
 arch/powerpc/kernel/process.c        | 3 ---
 drivers/crypto/vmx/aes.c             | 3 +++
 drivers/crypto/vmx/aes_cbc.c         | 3 +++
 drivers/crypto/vmx/aes_ctr.c         | 3 +++
 drivers/crypto/vmx/ghash.c           | 4 ++++
 6 files changed, 14 insertions(+), 3 deletions(-)

-- 
2.1.0
