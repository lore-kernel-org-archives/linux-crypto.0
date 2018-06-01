From: Haren Myneni <haren@linux.vnet.ibm.com>
Subject: Re: [PATCH] crypto/nx: Initialize 842 high and normal RxFIFO control
 registers
Date: Thu, 31 May 2018 23:30:32 -0700
Message-ID: <5B10E808.3030502@linux.vnet.ibm.com>
References: <1527789287.5945.23.camel@hbabu-laptop>
 <87sh672mf7.fsf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linuxppc-dev@lists.ozlabs.org, herbert@gondor.apana.org.au,
 linux-crypto@vger.kernel.org
To: Stewart Smith <stewart@linux.ibm.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <87sh672mf7.fsf@linux.vnet.ibm.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Id: linux-crypto.vger.kernel.org

On 05/31/2018 08:52 PM, Stewart Smith wrote:
> Haren Myneni <haren@linux.vnet.ibm.com> writes:
>> NX increments readOffset by FIFO size in receive FIFO control register
>> when CRB is read. But the index in RxFIFO has to match with the
>> corresponding entry in FIFO maintained by VAS in kernel. Otherwise NX
>> may be processing incorrect CRBs and can cause CRB timeout.
>>
>> VAS FIFO offset is 0 when the receive window is opened during
>> initialization. When the module is reloaded or in kexec boot, readOffset
>> in FIFO control register may not match with VAS entry. This patch adds
>> nx_coproc_init OPAL call to reset readOffset and queued entries in FIFO
>> control register for both high and normal FIFOs.
>>
>> Signed-off-by: Haren Myneni <haren@us.ibm.com>
> 
> I've yet to go and check out the skiboot patch properly, but should this
> be both:
> Fixes: b0d6c9bab crypto/nx: Add P9 NX support for 842 compression engine
> CC: stable # v4.14+
> 
> as otherwise "rmmod ; insmod" will crash, and possibly even issues over kexec?
> 

Correct, P9 NX support is included in 4.14. We also need fix in stable trees (4.14+). But this patch will not apply cleanly. I will post different patch for 4.14 and 4.16 stable trees. 

Thanks
Haren
