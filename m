From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Subject: Re: [PATCH v2 1/3] ima: use ahash API for file hash calculation
Date: Wed, 2 Jul 2014 21:40:17 +0300
Message-ID: <CACE9dm_S-a-ifJN4J+uU4GNy=-oP5h1PrU9x14CY1f0mnPZ-XA@mail.gmail.com>
References: <cover.1404245510.git.d.kasatkin@samsung.com>
	<72d68808fd8db2b896a459b120f3e550e5f976c1.1404245510.git.d.kasatkin@samsung.com>
	<53B45095.80102@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
	linux-ima-devel@lists.sourceforge.net,
	linux-security-module <linux-security-module@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	Dmitry Kasatkin <d.kasatkin@samsung.com>
To: Dave Hansen <dave.hansen@intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <53B45095.80102@intel.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 2 July 2014 21:33, Dave Hansen <dave.hansen@intel.com> wrote:
> On 07/01/2014 01:12 PM, Dmitry Kasatkin wrote:
>> +     ima_ahash=      [IMA] Asynchronous hash usage parameters
>> +                     Format: <min_file_size>
>> +                     Set the minimal file size when use asynchronous hash.
>> +                     If ima_ahash is not provided, ahash usage is disabled.
>
> <groan> ... another boot option...
>
> Can we just set this to something sane, and then make a sysctl or
> something else at runtime to tweak it?  The kernel won't use IMA much
> before userspace comes up, and it can surely live with a slightly
> suboptimal tuning until the boot scripts have a chance to go bang the
> tunable.
>
> We should reserve command-line parameters for things that really need
> tweaking in early boot or are _needed_ to boot.

Thanks... Good that you commented about it.
I thought to have module_param, but as IMA is not a module, ended up
with __setup..
Quite many always-builtin stuff use module_param... Also in LSM...
Runtime can then tweak it for better performance...

Is module param good enough or it should be sysctl?

- Dmitry
