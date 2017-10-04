From: P J P <ppandit@redhat.com>
Subject: Re: [Part2 Patch v4.2] crypto: ccp: Add Platform Security Processor
 (PSP) device support
Date: Wed, 4 Oct 2017 12:06:42 +0530 (IST)
Message-ID: <nycvar.YSQ.7.76.1710041202020.19122@wniryva>
References: <20170919204627.3875-6-brijesh.singh@amd.com> <20171002164344.12750-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: bp@suse.de, Paolo Bonzini <pbonzini@redhat.com>,
        =?ISO-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Gary Hook <gary.hook@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Brijesh Singh <brijesh.singh@amd.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171002164344.12750-1-brijesh.singh@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

+-- On Mon, 2 Oct 2017, Brijesh Singh wrote --+
| +int psp_dev_init(struct sp_device *sp)
| +{
| +	struct device *dev = sp->dev;
| +	struct psp_device *psp;
| +	int ret;
| +
| +	ret = -ENOMEM;
| +	psp = psp_alloc_struct(sp);
| +	if (!psp)
| +		goto e_err;
| +
| +       sp->psp_data = psp;
| ...
| +e_err:
| +	sp->psp_data = NULL;

Needs to kfree(sp->psp_data) before setting to NULL.

--
 - P J P
47AF CE69 3A90 54AA 9045 1053 DD13 3D32 FE5B 041F
