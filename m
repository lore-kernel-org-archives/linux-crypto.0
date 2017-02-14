From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] crypto: cavium - Add Support for Octeon-tx CPT Engine
Date: Tue, 14 Feb 2017 11:28:49 +0300
Message-ID: <20170214082848.GA12537@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: george.cherian@cavium.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38751 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750859AbdBNI3B (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Feb 2017 03:29:01 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello George Cherian,

The patch 9e2c7d99941d: "crypto: cavium - Add Support for Octeon-tx
CPT Engine" from Feb 7, 2017, leads to the following static checker
warning:

	drivers/crypto/cavium/cpt/cptpf_mbox.c:70 cpt_bind_vq_to_grp()
	warn: signedness bug returning '(-22)'

drivers/crypto/cavium/cpt/cptpf_mbox.c
    62  static u8 cpt_bind_vq_to_grp(struct cpt_device *cpt, u8 q, u8 grp)
               ^^
    63  {
    64          struct microcode *mcode = cpt->mcode;
    65          union cptx_pf_qx_ctl pf_qx_ctl;
    66          struct device *dev = &cpt->pdev->dev;
    67  
    68          if (q >= CPT_MAX_VF_NUM) {
    69                  dev_err(dev, "Queues are more than cores in the group");
    70                  return -EINVAL;
                        ^^^^^^^^^^^^^^^
    71          }
    72          if (grp >= CPT_MAX_CORE_GROUPS) {
    73                  dev_err(dev, "Request group is more than possible groups");
    74                  return -EINVAL;
                        ^^^^^^^^^^^^^^^
    75          }
    76          if (grp >= cpt->next_mc_idx) {
    77                  dev_err(dev, "Request group is higher than available functional groups");
    78                  return -EINVAL;
                        ^^^^^^^^^^^^^^^
    79          }
    80          pf_qx_ctl.u = cpt_read_csr64(cpt->reg_base, CPTX_PF_QX_CTL(0, q));
    81          pf_qx_ctl.s.grp = mcode[grp].group;
    82          cpt_write_csr64(cpt->reg_base, CPTX_PF_QX_CTL(0, q), pf_qx_ctl.u);
    83          dev_dbg(dev, "VF %d TYPE %s", q, (mcode[grp].is_ae ? "AE" : "SE"));
    84  
    85          return mcode[grp].is_ae ? AE_TYPES : SE_TYPES;
    86  }

regards,
dan carpenter
