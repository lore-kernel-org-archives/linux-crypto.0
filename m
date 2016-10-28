From: Gianfranco Costamagna <locutusofborg@debian.org>
Subject: Re: [PATCH] crypto: mxs-dcp - Remove hash support
Date: Fri, 28 Oct 2016 15:46:13 +0000 (UTC)
Message-ID: <1477960343.1079728.1477669573195@mail.yahoo.com>
References: <1477327226-2904-1-git-send-email-festevam@gmail.com> <CACJOhtJqx6+QN9gefSWtw_vgR3vps7tobXLQdbGM7FeUum_C3A@mail.gmail.com> <CACJOhtLFGOmrLZfPjb7TXPTcqPAdCXn6H7HEHG-8iQN3Z6gJnA@mail.gmail.com>
Reply-To: Gianfranco Costamagna <locutusofborg@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: "To: Fabio Estevam" <festevam@gmail.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "marex@denx.de" <marex@denx.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nm13-vm8.bullet.mail.ir2.yahoo.com ([212.82.96.187]:60701 "EHLO
        nm13-vm8.bullet.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1761181AbcJ1PwO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Oct 2016 11:52:14 -0400
In-Reply-To: <CACJOhtLFGOmrLZfPjb7TXPTcqPAdCXn6H7HEHG-8iQN3Z6gJnA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,
(sending with my debian.org mail address to avoid spam filters)
I tested the patch and indeed solves my problem (the driver loads correctly now with no warnings)

Tested-by: Gianfranco Costamagna <gianfranco.costamagna@abinsula.com>'


Just a side note about the patch

 
        if (sdcp->caps & MXS_DCP_CAPABILITY1_SHA1) {
                ret = crypto_register_ahash(&dcp_ sha1_alg);
                if (ret) {
                        dev_err(dev, "Failed to register %s hash!\n",
                                 dcp_sha1_alg.halg.base.cra_ name);
                        goto err_unregister_aes;
                }


-err_unregister_aes:
-       if (sdcp->caps & MXS_DCP_CAPABILITY1_AES128)
-               crypto_unregister_algs(dcp_ae s_algs, ARRAY_SIZE(dcp_aes_algs));
-
 err_destroy_aes_thread:
        kthread_stop(sdcp->thread[DCP_ CHAN_CRYPTO]);



seems that in case of SHA1 register failure, the unregister was done on aes algorithm.

Probably a bad copy-paste, but removing such code will obviously fix it.


thanks,
Gianfranco
