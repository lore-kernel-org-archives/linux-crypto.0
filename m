From: Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: linux-next: Tree for Jan 23 (mtd/ubi and iio and crypto/crc32[c])
Date: Sat, 26 Jan 2013 10:02:42 +0000
Message-ID: <5103A9C2.40206@cam.ac.uk>
References: <20130123174336.47c0113740a14da7f6a92187@canb.auug.org.au>
 <51006DC9.30802@infradead.org> <20130123232316.GB25726@gondor.apana.org.au>
 <51007545.5040406@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Artem Bityutskiy <dedekind1@gmail.com>, linux-iio@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
 linux-mtd@lists.infradead.org, linux-crypto@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
In-Reply-To: <51007545.5040406@infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: linux-mtd-bounces@lists.infradead.org
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

On 01/23/2013 11:41 PM, Randy Dunlap wrote:
> On 01/23/13 15:23, Herbert Xu wrote:
>> On Wed, Jan 23, 2013 at 03:10:01PM -0800, Randy Dunlap wrote:
>>> On 01/22/13 22:43, Stephen Rothwell wrote:
>>>> Hi all,
>>>>
>>>> Changes since 20130122:
>>>>
>>>
>>>
>>> on i386:
>>>
>>> ERROR: "crc32_le" [drivers/mtd/ubi/ubi.ko] undefined!
>>> ERROR: "iio_triggered_buffer_setup" [drivers/iio/adc/max1363.ko] undefined!
>>> ERROR: "iio_triggered_buffer_cleanup" [drivers/iio/adc/max1363.ko] undefined!
>>> ERROR: "__crc32c_le" [crypto/crc32c.ko] undefined!
>>> ERROR: "crc32_le" [crypto/crc32.ko] undefined!
>>
>> Weird.  You do have CONFIG_CRC32 selected, so did it compile
>> a lib/crc32.ko or not?
> 
> Hmph, this seems to be some kind of rebuild problem.  It's not
> reproducible, so the mtd/ubi and crypto reports above are incorrect --
> please ignore them.  Only the iio one is reproducible.
> 
> Sorry about that.
> 
For iio one had a patch for a while, just not had a chance to send
a pull request to Greg until today.  Sorry for the slow response.

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
