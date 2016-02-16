From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH v5 1/3] crypto: KEYS: convert public key and digsig asym
 to the akcipher api
Date: Tue, 16 Feb 2016 12:37:03 -0800
Message-ID: <56C3886F.3050009@intel.com>
References: <16626.1455184286@warthog.procyon.org.uk>
 <56BBC321.1000503@intel.com> <20160202180853.2887.82271.stgit@tstruk-mobl1>
 <20160202180848.2887.9937.stgit@tstruk-mobl1>
 <5286.1455113876@warthog.procyon.org.uk>
 <17832.1455185317@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, zohar@linux.vnet.ibm.com
To: David Howells <dhowells@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <17832.1455185317@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi David,
On 02/11/2016 02:08 AM, David Howells wrote:
> David Howells <dhowells@redhat.com> wrote:
> 
>> > Tadeusz Struk <tadeusz.struk@intel.com> wrote:
>> > 
>>>> > > > Why didn't you put the RSA signature parsing - ie. where the OID and the other
>>>> > > > bits are checked - into crypto/rsa.c?
>>>> > > > 
>>> > > 
>>> > > Do you want to get rid of the crypto/asymmetric_keys/rsa.c completely?
>>> > > I wanted to make the conversion churn as small as possible.
>>> > > I can move it in a subsequent patch if you want.
>> > 
>> > I was thinking of getting rid of it completely, yes.
>> > 
>> > But I was wondering if you had some other motivation, such as keeping the
>> > crypto layer purely the mathematical operation.
>> > 
>> > It's an interesting question where to draw the line, actually.  The answer may
>> > hinge on what things like the TPM do.  I should ask the TPM folks.
> Looking in the TPM emulator, the TPM_Sign operation indeed puts the wrappings
> on, so this needs to go into the crypto layer.

David,
If you could tell me what repo should I work with then I can prepare subsequent patch to
move this to a new file under crypto/
Thanks,
-- 
TS
