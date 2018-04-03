From: Vaneet Narang <v.narang@samsung.com>
Subject: RE: Re: [PATCH 1/1] lz4: Implement lz4 with dynamic offset length.
Date: Tue, 03 Apr 2018 19:13:47 +0530
Message-ID: <576192949.596772.1522763027665.JavaMail.jboss@ep1ml501>
References: <20180403122642.GA26934@jagdpanzerIV>
        <20180321074948.GA2746@jagdpanzerIV>
        <1521607242-3968-1-git-send-email-maninder1.s@samsung.com>
        <1521607242-3968-2-git-send-email-maninder1.s@samsung.com>
        <20180402055152epcms5p546fdb62381b769ed0c719f3bedcee3b8@epcms5p5>
        <CGME20180321044149epcas5p12cba1afa5fc0f493a47fe20c4a7394bd@epcms5p7>
Reply-To: v.narang@samsung.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
        boundary="----=_Part_596771_1741584878.1522763027665"
Cc: "sergey.senozhatsky.work@gmail.com"
        <sergey.senozhatsky.work@gmail.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "minchan@kernel.org" <minchan@kernel.org>,
        "ngupta@vflare.org" <ngupta@vflare.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "anton@enomsg.org" <anton@enomsg.org>,
        "ccross@android.com" <ccross@android.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "colin.king@canonical.com" <colin.king@canonical.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        PANKAJ MISHRA <pankaj.m@samsung.com>,
        AMIT SAHRAWAT <a.sahrawat@samsung.com>
To: Maninder Singh <maninder1.s@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180403122642.GA26934@jagdpanzerIV>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

------=_Part_596771_1741584878.1522763027665
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"

Hi Sergey,

>You shrink a 2 bytes offset down to a 1 byte offset, thus you enforce that
2 Byte offset is not shrinked to 1 byte, Its only 1 bit is reserved out of
16 bits of offset. So only 15 Bits can be used to store offset value.

>'page should be less than 32KB', which I'm sure will be confusing. 
lz4_dyn will work on bigger data length(> 32k) but in that case compression
ratio may not be better than LZ4. This is same as LZ4 compressing data more 
than 64K (16Bits). LZ4 can't store offset more than 64K similarly
LZ4 dyn can't store offset more than 32K.

There is a handling in LZ4 code for this and similar handling added for LZ4 Dyn.

Handling in LZ4 Dyn: max_distance is 32K for lz4_dyn and will be 64K for LZ4
int max_distance = dynOffset ? MAX_DISTANCE_DYN : MAX_DISTANCE;

>And you
>rely on lz4_dyn users to do the right thing - namely, to use that 'nice'
>`#if (PAGE_SIZE < (32 * KB))'. 
They don't need to add this code, they just need to choose right compression algorithm 
that fits their requirement. If source length is less than 32K then lz4_dyn 
would give better compression ratio then LZ4. 

Considering ZRAM as a user for LZ4 dyn, we have added this check for PAGE_SIZE which
is source length. This code adds lz4 dyn to preferred list of compression algorithm 
when PAGE size is less than 32K. 

>Apart from that, lz4_dyn supports only data
>in up to page_size chunks. Suppose my system has page_size of less than 32K,
>so I legitimately can enable lz4_dyn, but suppose that I will use it
>somewhere where I don't work with page_size-d chunks. Will I able to just
>do tfm->compress(src, sz) on random buffers? The whole thing looks to be
>quite fragile.
No thats not true, lz4_dyn can work for random buffers and it need not be 
of page size chunks. There is no difference in Lz4 and Lz4 dyn working. 

Only difference is LZ4 dyn doesn't use fixed offset size, this concept already getting 
used in LZO which uses dynamic size of Metadata based on Match Length and Match offset.
It uses different markers for this which defines length of meta data.

lzodefs.h:

#define M1_MAX_OFFSET   0x0400
#define M2_MAX_OFFSET   0x0800
#define M3_MAX_OFFSET   0x4000
#define M4_MAX_OFFSET   0xbfff

#define M1_MIN_LEN      2
#define M1_MAX_LEN      2
#define M2_MIN_LEN      3
#define M2_MAX_LEN      8
#define M3_MIN_LEN      3
#define M3_MAX_LEN      33
#define M4_MIN_LEN      3
#define M4_MAX_LEN      9

#define M1_MARKER       0
#define M2_MARKER       64
#define M3_MARKER       32
#define M4_MARKER       16

Similarly for LZ4 Dyn, we have used 1 bit as a marker to determine offset length.

Thanks & Regards,
Vaneet Narang
------=_Part_596771_1741584878.1522763027665
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="rcptInfo.txt"
Content-Transfer-Encoding: base64

DQogICA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT0NCiAgICAgIFN1YmplY3QgICAgOiBSZTogW1BBVENIIDEvMV0g
bHo0OiBJbXBsZW1lbnQgbHo0IHdpdGggZHluYW1pYyBvZmZzZXQgbGVuZ3RoLg0KICAgICAgRnJv
bSAgICAgICA6IG51bGwNCiAgICAgIFNlbnQgRGF0ZSAgOiAyMDE4LTA0LTAzIDE3OjU2ICBHTVQr
NTozMA0KICAgPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09DQogICAgICAgICAgICAgICAgICBOYW1lICAgICAgICAg
ICAgICAgIFR5cGUgICAgICAgICAgSm9iIFRpdGxlICAgICAgICAgICAgICAgICAgICAgICBEZXB0
LiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBDb21wYW55ICAgICAgICAgICAgICAgIA0K
ICAgPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09DQogICAgICBNYW5pbmRlciBTaW5naCAgICAgICAgICAgICAgICAg
VE8gICAgICAgICBFbmdpbmVlciAgICAgICAgICAgICAgICAgICBTUkktRGVsaGktUGxhdGZvcm0g
Uy9XIDEgVGVhbSAgICAgICAgICAgICBTYW1zdW5nwqBFbGVjdHJvbmljc8KgDQogICAgICBzZXJn
ZXkuc2Vub3poYXRza3kud29ya0BnLi4uICAgQ0MNCiAgICAgIGhlcmJlcnRAZ29uZG9yLmFwYW5h
Lm9yZy5hdSAgICBDQw0KICAgICAgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldCAgICAgICAgICAgIENDDQog
ICAgICBtaW5jaGFuQGtlcm5lbC5vcmcgICAgICAgICAgICAgQ0MNCiAgICAgIG5ndXB0YUB2Zmxh
cmUub3JnICAgICAgICAgICAgICBDQw0KICAgICAga2Vlc2Nvb2tAY2hyb21pdW0ub3JnICAgICAg
ICAgIENDDQogICAgICBhbnRvbkBlbm9tc2cub3JnICAgICAgICAgICAgICAgQ0MNCiAgICAgIGNj
cm9zc0BhbmRyb2lkLmNvbSAgICAgICAgICAgICBDQw0KICAgICAgdG9ueS5sdWNrQGludGVsLmNv
bSAgICAgICAgICAgIENDDQogICAgICBha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnICAgICAgQ0MN
CiAgICAgIGNvbGluLmtpbmdAY2Fub25pY2FsLmNvbSAgICAgICBDQw0KICAgICAgbGludXgtY3J5
cHRvQHZnZXIua2VybmVsLm9yZyAgIENDDQogICAgICBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwu
b3JnICAgQ0MNCiAgICAgIFBBTktBSiBNSVNIUkEgICAgICAgICAgICAgICAgICBDQyAgICAgICAg
IFByaW5jaXBhbCBQcm9mZXNzaW9uYWwgICAgIFNSSS1EZWxoaS1QbGF0Zm9ybSBTL1cgMSBUZWFt
ICAgICAgICAgICAgIFNhbXN1bmfCoEVsZWN0cm9uaWNzDQogICAgICBBTUlUIFNBSFJBV0FUICAg
ICAgICAgICAgICAgICAgQ0MgICAgICAgICBTdGFmZiBFbmdpbmVlciAgICAgICAgICAgICBTUkkt
RGVsaGktUGxhdGZvcm0gUy9XIDEgVGVhbSAgICAgICAgICAgICBTYW1zdW5nwqBFbGVjdHJvbmlj
cw0KICAgICAgVmFuZWV0IE5hcmFuZyAgICAgICAgICAgICAgICAgIENDICAgICAgICAgU3RhZmYg
RW5naW5lZXIgICAgICAgICAgICAgU1JJLURlbGhpLVBsYXRmb3JtIFMvVyAxIFRlYW0gICAgICAg
ICAgICAgU2Ftc3VuZyBFbGVjdHJvbmljcw0KICAgPT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQo=

------=_Part_596771_1741584878.1522763027665--
