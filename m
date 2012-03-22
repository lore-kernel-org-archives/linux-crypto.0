From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/2] crypto: camellia-x86_64 - module init/exit functions
 should be static
Date: Thu, 22 Mar 2012 14:18:01 -0700
Message-ID: <4F6B9709.1040701@zytor.com>
References: <4F620F37.4070404@xenotime.net> <20120315201151.11667.63183.stgit@localhost6.localdomain6> <4F6A74E3.7080901@xenotime.net> <20120322004646.GA8489@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Randy Dunlap <rdunlap@xenotime.net>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20120322004646.GA8489@gondor.apana.org.au>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 03/21/2012 05:46 PM, Herbert Xu wrote:
> On Wed, Mar 21, 2012 at 05:40:03PM -0700, Randy Dunlap wrote:
>> On 03/15/2012 01:11 PM, Jussi Kivilinna wrote:
>>
>>> This caused conflict with twofish-x86_64-3way when compiled into kernel,
>>> same function names and not static.
>>
>> Have these patches been merged anywhere?
>> I'm still seeing build problems in linux-next 20120321.
> 
> Thanks for the reminder, I'll push these through today.

Please push these to Linus ASAP, it is breaking the x86-64 allyesconfig
build upstream right now.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
