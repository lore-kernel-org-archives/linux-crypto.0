From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH crypto-2.6] crypto: ccp: add timeout support in the SEV
 command
Date: Mon, 10 Sep 2018 14:06:57 -0500
Message-ID: <e327fa7f-2d4d-2181-c3f4-607faf16c9b5@amd.com>
References: <1534367485-4386-1-git-send-email-brijesh.singh@amd.com>
 <1534367485-4386-2-git-send-email-brijesh.singh@amd.com>
 <20180904081151.GC32615@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: brijesh.singh@amd.com, linux-crypto@vger.kernel.org,
        thomas.lendacky@amd.com, Gary Hook <Gary.Hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180904081151.GC32615@zn.tnic>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Boris,


On 09/04/2018 03:11 AM, Borislav Petkov wrote:
...

>> +
>> +static int psp_probe_timeout = 5;
>> +module_param(psp_probe_timeout, int, 0644);
>> +MODULE_PARM_DESC(psp_probe_timeout, " default timeout value, in seconds, during PSP device probe");
> 
> Just a question: what prevents the user from supplying non-sensical
> values here?
> 
> I think we should clamp them to only allowed values because I don't want
> to be debugging some strange bugs due to that.
> 

Nothing prevent user from supplying a bogus number. The main question
is, clamp with what number ?

IMO, if user is overriding the default timeout number then its possible
that user is dealing with a buggy firmware which does not work with
default timeout and silently clamping the value will not help them.


- Brijesh
