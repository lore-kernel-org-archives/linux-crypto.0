From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH v2 1/3] ima: use ahash API for file hash calculation
Date: Wed, 02 Jul 2014 11:33:57 -0700
Message-ID: <53B45095.80102@intel.com>
References: <cover.1404245510.git.d.kasatkin@samsung.com> <72d68808fd8db2b896a459b120f3e550e5f976c1.1404245510.git.d.kasatkin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Dmitry Kasatkin <d.kasatkin@samsung.com>
To: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
	zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
	linux-security-module@vger.kernel.org
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <72d68808fd8db2b896a459b120f3e550e5f976c1.1404245510.git.d.kasatkin@samsung.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 07/01/2014 01:12 PM, Dmitry Kasatkin wrote:
> +	ima_ahash=	[IMA] Asynchronous hash usage parameters
> +			Format: <min_file_size>
> +			Set the minimal file size when use asynchronous hash.
> +			If ima_ahash is not provided, ahash usage is disabled.

<groan> ... another boot option...

Can we just set this to something sane, and then make a sysctl or
something else at runtime to tweak it?  The kernel won't use IMA much
before userspace comes up, and it can surely live with a slightly
suboptimal tuning until the boot scripts have a chance to go bang the
tunable.

We should reserve command-line parameters for things that really need
tweaking in early boot or are _needed_ to boot.
