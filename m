Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C5B1C433F5
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Oct 2022 18:02:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbiJFSCc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Oct 2022 14:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbiJFSCb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Oct 2022 14:02:31 -0400
Received: from mail-0201.mail-europe.com (mail-0201.mail-europe.com [51.77.79.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18501BD061;
        Thu,  6 Oct 2022 11:02:30 -0700 (PDT)
Date:   Thu, 06 Oct 2022 18:02:14 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail3; t=1665079346; x=1665338546;
        bh=vg0I80ZZ/aeSUoxTv9FSi8jw1ZLp13nSPNGlcvz8ix0=;
        h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID;
        b=V4slbBRImaekHPUJeLcN0VZFAGLNq2qjcYafCifNX3xQayi87Y33+7sXE76QyAKFq
         0a+jp8tUekW7jcCOOBgSmVoY+QgE/3Zj2RV1pDm3f8VDKDC+d+NCctotJej2GT5zof
         Tc4FksrjH4kSHyjjNE77hCOcILhMy3lbsPKyZtcIPYQZWtYa/IlDv3F/kl6Sk/POPX
         W/MOUk/bFnrRijrJGA6/FoyAZwovu3Ghb1MibkpP9SBdGkNW8jrhVMtnpDtsyixM/F
         1QQ8RQNKFxU3LgTEF89Pc+h3ykkHeMktx6CGRYAScR2q9VHPMujhiqc8DljoJfDEPn
         1hf8HGIFIWSTQ==
To:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
From:   Jari Ruusu <jariruusu@protonmail.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Announce loop-AES-v3.7y file/swap crypto package
Message-ID: <6gzebvo82qyS8fwpW22mKEJNvBMnI6juOKE_n7x5Zxq1_ceighRjYoZiNbed5TmI7scxDhgSuFBN7K8W-CDPyRw8WLVJzXFLEl7qGxdPwF4=@protonmail.com>
Feedback-ID: 22639318:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

loop-AES changes since previous release:
- Fixed possible use-after-free bug in module removal code.
- Worked around kernel interface changes on 5.19.12+ and 6.x kernels.
- Some #ifdef spaghetti removed for 6.x kernels.

bzip2 compressed tarball is here:

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.7y.tar.bz2
    md5sum 87b58c0c4ef53da59fb7e853702b594d

    http://loop-aes.sourceforge.net/loop-AES/loop-AES-v3.7y.tar.bz2.sign

--
Jari Ruusu=C2=A0 4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD=C2=A0 ACDF F073 3C=
80 8132 F189

