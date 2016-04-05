From: Nicolai Stange <nicstange@gmail.com>
Subject: Re: [PATCH v3 00/14] lib/mpi: bug fixes and cleanup
Date: Tue, 05 Apr 2016 14:49:01 +0200
Message-ID: <874mbgte4i.fsf@gmail.com>
References: <1458648768-1469-1-git-send-email-nicstange@gmail.com>
	<20160405124733.GJ13048@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Nicolai Stange <nicstange@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Michal Marek <mmarek@suse.com>,
	Andrzej Zaborowski <andrew.zaborowski@intel.com>,
	Stephan Mueller <smueller@chronox.de>,
	Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160405124733.GJ13048@gondor.apana.org.au> (Herbert Xu's
	message of "Tue, 5 Apr 2016 20:47:33 +0800")
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> writes:

> On Tue, Mar 22, 2016 at 01:12:34PM +0100, Nicolai Stange wrote:
>> Former v2 can be found here:
>> 
>>   http://lkml.kernel.org/g/1458566775-5239-1-git-send-email-nicstange@gmail.com
>> 
>> 
>> This v3 series incorporates a fix to the pointer arithmetic issue in v2's
>> [8/14] ("lib/mpi: mpi_read_buffer(): fix buffer overflow") spotted by
>> Tadeusz Struk.
>> 
>> The rest, that is [1-7,9-14/14], go unchanged and have got a
>> 
>>   Tested-by: Tadeusz Struk <tadeusz.struk@intel.com>
>> 
>> already.
>> 
>> 
>> Applicable to linux-next-20160322.
>
> All applied.

Thank you very much :)
