From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] crypto: lrw - Convert to skcipher
Date: Thu, 18 Jan 2018 13:44:15 +0300
Message-ID: <20180118104415.GB21064@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:33282 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755489AbeARKpH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jan 2018 05:45:07 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Herbert Xu,

The patch 700cb3f5fe75: "crypto: lrw - Convert to skcipher" from Nov
22, 2016, leads to the following static checker warning:

	crypto/lrw.c:316 exit_crypt()
	warn: should '(struct rctx)->ext' be freed with kzfree()'

crypto/lrw.c
   309  static void exit_crypt(struct skcipher_request *req)
   310  {
   311          struct rctx *rctx = skcipher_request_ctx(req);
   312  
   313          rctx->left = 0;
   314  
   315          if (rctx->ext)
   316                  kfree(rctx->ext);
                        ^^^^^^^^^^^^^^^^

I am working on a Smatch check that complains about stuff we should
maybe free with kzfree.  It first makes a list of any struct members
which are freed with kzfree() then it does a second pass and complains
if any of them are freed with regular kfree().

   317  }

Here is the complete list of warnings from v4.15-rc8.  It's not very
long...

crypto/lrw.c:316 exit_crypt() warn: should '(struct rctx)->ext' be freed with kzfree()'
drivers/crypto/virtio/virtio_crypto_core.c:411 virtcrypto_free_unused_reqs() warn: should '(struct virtio_crypto_request)->req_data' be freed with kzfree()'
drivers/net/wireless/intersil/orinoco/wext.c:78 orinoco_set_key() warn: should '(struct key_params)->key' be freed with kzfree()'
drivers/staging/wlan-ng/p80211conv.c:216 skb_ether_to_p80211() warn: should '(struct p80211_metawep)->data' be freed with kzfree()'
fs/cifs/connect.c:1710 cifs_parse_mount_options() warn: should '(struct smb_vol)->password' be freed with kzfree()'
fs/cifs/connect.c:1748 cifs_parse_mount_options() warn: should '(struct smb_vol)->password' be freed with kzfree()'
fs/cifs/connect.c:4238 cifs_construct_tcon() warn: should '(struct smb_vol)->password' be freed with kzfree()'
security/apparmor/crypto.c:102 aa_calc_profile_hash() warn: should '(struct aa_profile)->hash' be freed with kzfree()'

regards,
dan carpenter
