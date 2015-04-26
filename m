From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH v3 0/5] target: Fix several problems related to T10-PI
 support
Date: Sun, 26 Apr 2015 13:33:43 +0300
Message-ID: <553CBF07.6080902@dev.mellanox.co.il>
References: <1429972410-7146-1-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Nicholas Bellinger <nab@linux-iscsi.org>,
	Sagi Grimberg <sagig@mellanox.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
To: Akinobu Mita <akinobu.mita@gmail.com>, target-devel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:34432 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbbDZKeG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 26 Apr 2015 06:34:06 -0400
Received: by wgso17 with SMTP id o17so89562827wgs.1
        for <linux-crypto@vger.kernel.org>; Sun, 26 Apr 2015 03:34:05 -0700 (PDT)
In-Reply-To: <1429972410-7146-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 4/25/2015 5:33 PM, Akinobu Mita wrote:
> This patchset aims to fix several problems related to T10-PI support.
>
> These patches can be applied on top of Sagi's "[v1] Simlify dif_verify
> routines and fixup fileio protection information code" patchset.
>

Hi Akinobu,

I have given this some more thought,

This set adds DIF protected WRITE_SAME support. I don't think this
will work with a real transport that offload DIF computation (at least
not over RDMA - perhaps qlogic/emulex folks can comment on their
devices).

The problem is that the HBA does not have the write_same functionality
you introduce here, i.e. generate multiple same protection fields for a
single data block.

We can require the fabrics drivers to do that (probably compensate in
SW) or, we can have the write_same logic to live only in the
core/backend code.

In this case, for WRITE_SAME, have the fabrics generate/verify a single
data block (one integrity field) like they do today, and then the core
will expand it to the correct number of sectors using some form of
sbc_dif_expand_same()

I'm not sure which way is better...

Martin? Nic? Thoughts?
