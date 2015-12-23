From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH v2 1/2] crypto: KEYS: convert public key to the akcipher
 api
Date: Tue, 22 Dec 2015 20:57:57 -0800
Message-ID: <567A29D5.8090503@intel.com>
References: <201512200735.x3U85zQL%fengguang.wu@intel.com>
 <5678684F.2020308@gmail.com> <20151222120919.GA25163@gondor.apana.org.au>
 <56795CFF.1080106@intel.com> <20151223023343.GA31104@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Tadeusz Struk <tstruk@gmail.com>,
	kbuild test robot <lkp@intel.com>, kbuild-all@01.org,
	linux-kernel@vger.kernel.org, dhowells@redhat.com,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, zohar@linux.vnet.ibm.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151223023343.GA31104@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 12/22/2015 06:33 PM, Herbert Xu wrote:
>> What about the first two. This one is completely unrelated.
>> > It only supposed to fix some random configuration issue
>> > reported by a build robot, which isn't really important now.
>> > The other two convert the module verifier to the new API.
> No this compile breakage was introduced by your first two patches
> because you changed crypto/public_key.h which is used by entities
> outside of your patch.
> 
> So fix your first two patches by not breaking existing users
> of it.
Ok I can see the problem now. I just don't should not include
the asymmetric-type.h in the public_key.h and it fixes it.
Will send v3 soon.
Thanks,
-- 
TS
