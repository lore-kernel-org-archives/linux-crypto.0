From: Fabrizio Demaria <fabrizio.f.demaria@gmail.com>
Subject: "crypto_hash_setkey" call from atomic context
Date: Thu, 10 Dec 2015 16:59:31 +0100
Message-ID: <CACzeOEfg9x+aEwuP9xH3BLd5+RzpDBZBGsnsLw7skW9FP5LVGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Nordell, Joakim" <joakim.nordell@intel.com>,
	"Chen, Shujuan" <shujuan.chen@intel.com>, doru.gucea@intel.com
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:36324 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbbLJP7c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Dec 2015 10:59:32 -0500
Received: by mail-ig0-f170.google.com with SMTP id ph11so18464757igc.1
        for <linux-crypto@vger.kernel.org>; Thu, 10 Dec 2015 07:59:31 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

I am investigating the current usage of kernel crypto-libraries in the
SCTP code, considering to adopt the same crypto framework for the
MPTCP implementation.

In sm_make_chunk.c, the crypto function "crypto_hash_setkey" is called
in an atomic context, despite the fact that this function CAN invoke a
GFP_KERNEL (sleeping) memory allocation. Calling a sleeping function
from an atomic context can end up in deadlock.
Is there a way to make sure that =E2=80=9Ccrypto_hash_setkey=E2=80=9D c=
an be safely
called in an atomic context, considering all the possible code-paths
followed by the function?

Thanks,
=46abrizio
