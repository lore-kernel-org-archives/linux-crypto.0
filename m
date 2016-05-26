From: "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: RE: [PATCH 2/7] crypto : async implementation for sha1-mb
Date: Thu, 26 May 2016 21:25:14 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C712205DFB9511@ORSMSX106.amr.corp.intel.com>
References: <1463705008-2183-1-git-send-email-megha.dey@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "tim.c.chen@linux.intel.com" <tim.c.chen@linux.intel.com>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Megha Dey <megha.dey@linux.intel.com>
To: "Dey, Megha" <megha.dey@intel.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1463705008-2183-1-git-send-email-megha.dey@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

> From: Dey, Megha
> Sent: Thursday, May 19, 2016 5:43 PM
> To: herbert@gondor.apana.org.au
> Cc: tim.c.chen@linux.intel.com; davem@davemloft.net; linux-
> crypto@vger.kernel.org; linux-kernel@vger.kernel.org; Dey, Megha
> <megha.dey@intel.com>; Yu, Fenghua <fenghua.yu@intel.com>; Megha
> Dey <megha.dey@linux.intel.com>
> Subject: [PATCH 2/7] crypto : async implementation for sha1-mb
> 
> From: Megha Dey <megha.dey@linux.intel.com>
> 
> Herbert wants the sha1-mb algorithm to have an async implementation:
> https://lkml.org/lkml/2016/4/5/286.
> Currently, sha1-mb uses an async interface for the outer algorithm and a sync
> interface for the inner algorithm. This patch introduces a async interface for
> even the inner algorithm.
> 
> Signed-off-by: Megha Dey <megha.dey@linux.intel.com>
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> ---
>  arch/x86/crypto/sha-mb/sha1_mb.c | 190 ++++++++++++++++++++++------
> -----------
>  crypto/ahash.c                   |   6 --
>  crypto/mcryptd.c                 | 117 +++++++++++++-----------
>  include/crypto/hash.h            |   6 ++
>  include/crypto/internal/hash.h   |   8 +-
>  include/crypto/mcryptd.h         |   8 +-
>  6 files changed, 184 insertions(+), 151 deletions(-)
> 

Hi, Herbert,

Any comment/feedback on this patch set? Is there any plan to push it to upstream?

Thanks.

-Fenghua
